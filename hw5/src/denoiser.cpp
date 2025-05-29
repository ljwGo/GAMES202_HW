#include "denoiser.h"
#define BORDER_PIXEL 7

// Try to use SVGF
float Denoiser::DistWeightSVGF(int x, int y, int i, int j, const FrameInfo& frameInfo) {
    // First i consider distance is uv in screen. 
    //float dist = -std::sqrt((x - i) * (x - i) + (y - j) * (y - j));
    // Maybe use world space distance better.
    Float3 originPos = frameInfo.m_position(x, y);
    Float3 neighborPos = frameInfo.m_position(i, j);
    float dist = -Distance(originPos, neighborPos);
    return std::exp(dist / m_svgfSigmaCoord);
}

float Denoiser::NormalWeightSVGF(int x, int y, int i, int j,
                                 const FrameInfo &frameInfo) {
    Float3 n1 = Normalize(frameInfo.m_normal(x, y));
    Float3 n2 = Normalize(frameInfo.m_normal(i, j));
    return std::pow(std::max(0.f, Dot(n1, n2)), m_svgfSigmaNormal);
}

// I don't know gradient how to apply for sphere
float Denoiser::DepthWeightSVGF(int x, int y, int i, int j,
                      const FrameInfo &frameInfo){
    // Gradient declare: partial(i) + partial(j);
    float partialX, partialY;
    int width = frameInfo.m_beauty.m_width;
    int height = frameInfo.m_beauty.m_height;

    if (x == width - BORDER_PIXEL - 1) {
        partialX = frameInfo.m_depth(x, y) - frameInfo.m_depth(x - 1, y);
    } else {
        partialX = frameInfo.m_depth(x + 1, y) - frameInfo.m_depth(x, y);
    }

    if (y == height - BORDER_PIXEL - 1) {
        partialY = frameInfo.m_depth(x, y) - frameInfo.m_depth(x, y - 1);
    } else {
        partialY = frameInfo.m_depth(x, y + 1) - frameInfo.m_depth(x, y);
    }
    
    Float3 gradient = Float3(partialX, partialY, 0.);
    Float3 directVector = Float3(i - x, j - y, 0.);

    float esp = 0.001f;
    float depthDiff = -std::abs(frameInfo.m_depth(x, y) - frameInfo.m_depth(i, j));
    float denominator = m_svgfSigmaDepth * std::abs(Dot(gradient, directVector)) + esp;
    return std::exp(depthDiff / denominator);
}

// Pay attention to Length and SqrLength alloction.
float Denoiser::ColorWeightSVGF(int x, int y, int i, int j, const Float3& variance,
    const FrameInfo& frameInfo) {
    float esp = 0.001f;
    float colorDiff = -Length(frameInfo.m_beauty(i, j) - frameInfo.m_beauty(x, y));
    float denominator = m_svgfSigmaColor * SqrLength(variance) + esp;

    return std::exp(colorDiff / denominator);
}

float Denoiser::DistWeight(int x, int y, int i, int j, const FrameInfo &frameInfo) {
    // Maybe use world space distance better.
    Float3 originPos = frameInfo.m_position(x, y);
    Float3 neighborPos = frameInfo.m_position(i, j);
    float dist = -SqrDistance(originPos, neighborPos);
    return std::exp(dist * 0.5f / Sqr(m_sigmaCoord));
}

float Denoiser::NormalWeight(int x, int y, int i, int j, const FrameInfo &frameInfo) {
    // May cause acos(value more than one) error
    float cos =
        std::clamp(Dot(frameInfo.m_normal(x, y), frameInfo.m_normal(i, j)), -1.f, 1.f);
    float angle = std::acos(cos);
    float coef = -(angle * angle * 0.5) / Sqr(m_sigmaNormal);
    return std::exp(coef);
}

float Denoiser::DepthWeight(int x, int y, int i, int j, const FrameInfo& frameInfo) {
    // May cause divide zero error
    Float3 pOffset = Normalize(frameInfo.m_position(x, y) - frameInfo.m_position(i, j));
    float absCos = std::abs(Dot(pOffset, frameInfo.m_normal(x, y)));
    return std::exp(-(absCos * absCos * 0.5) / Sqr(m_sigmaPlane));
}

float Denoiser::ColorWeight(int x, int y, int i, int j, const Float3 &varianceColor,
                            const FrameInfo &frameInfo) {
    // Use neighbor variance.
    //Float3 meanColor;
    //Float3 varianceColor;
    //CalcColorMeanAndVariance(frameInfo.m_beauty, i, j, colorKernelRadius, meanColor,
    //                         varianceColor);

    // SqrLength is more effective because many noise value more than 1 or less than zero. POW make it bigger.
    // Normal egde different below 1(bigger) and noise different more than 1(smaller).
    float esp = 0.0001f;
    return std::exp(-Distance(frameInfo.m_beauty(x, y), frameInfo.m_beauty(i, j)) *
                    0.5f / (Sqr(m_sigmaColor) * (SqrLength(varianceColor)) + esp));
}

Denoiser::Denoiser() : m_useTemportal(false) {}

void Denoiser::CalcColorMeanAndVariance(const Buffer2D<Float3> &colorBuffer, int x, int y,
                                        int kernelRadius, Float3 &mean,
                                      Float3 &variance) {
    int height = colorBuffer.m_height;
    int width = colorBuffer.m_width;

    // In general, variance use mean to calc. But in order to distinguish noise and edge. I use current color.
    mean = Float3(0.0f);
    variance = Float3(0.0f);
    int lIx = std::max(x - kernelRadius, BORDER_PIXEL);
    int rIx = std::min(x + kernelRadius, width - BORDER_PIXEL - 1);
    int tIx = std::max(y - kernelRadius, BORDER_PIXEL);
    int bIx = std::min(y + kernelRadius, height - BORDER_PIXEL - 1);
    for (int i = lIx; i <= rIx; ++i) {
        for (int j = tIx; j <= bIx; ++j) {
            mean += colorBuffer(i, j);
            variance += Sqr(colorBuffer(i, j) - colorBuffer(x, y));
        }
    }
    int sum = (rIx - lIx + 1) * (bIx - tIx + 1);

    mean /= (float)sum;
    //for (int i = lIx; i <= rIx; ++i) {
    //    for (int j = tIx; j <= bIx; ++j) {
    //        variance += Sqr(colorBuffer(i, j) - mean);
    //    }
    //}
    variance /= (float)sum;
}

void Denoiser::Reprojection(const FrameInfo &frameInfo) {
    int height = frameInfo.m_beauty.m_height;
    int width = frameInfo.m_beauty.m_width;
    Matrix4x4 preWorldToScreen =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 1];
    Matrix4x4 preWorldToCamera =
        m_preFrameInfo.m_matrix[m_preFrameInfo.m_matrix.size() - 2];
#pragma omp parallel for
    for (int y = BORDER_PIXEL; y < height - BORDER_PIXEL; y++) {
        for (int x = BORDER_PIXEL; x < width - BORDER_PIXEL; x++) {
            // TODO: Reproject
            m_misc(x, y) = Float3(0.f);

            // World space
            Float3 pos = frameInfo.m_position(x, y);
            // Model space(calc model translate, rotate and scale)
            int id = frameInfo.m_id(x, y);
            Matrix4x4 preModelMat = m_preFrameInfo.m_matrix[id];
            Matrix4x4 modelMatInv = Inverse(frameInfo.m_matrix[id]);
            Float3 modelPos = preModelMat(modelMatInv(pos, Float3::Point), Float3::Point); 
            // posInScreen between [0, width - 1] and [0, height - 1]
            Float3 posInScreen = preWorldToScreen(modelPos, Float3::EType::Point);
            int xIx = int(posInScreen.x);
            int yIx = int(posInScreen.y);

            if (xIx < BORDER_PIXEL || xIx > width - BORDER_PIXEL || yIx < BORDER_PIXEL ||
                yIx > height - BORDER_PIXEL) {
                m_valid(x, y) = false;
                continue;
            }

            if (m_preFrameInfo.m_id(xIx, yIx) != frameInfo.m_id(x, y)) {
                m_valid(x, y) = false;
            } else {
                m_valid(x, y) = true;
            }

            m_misc(x, y) = m_accColor(xIx, yIx);
        }
    }
    // 将上一帧的结果位移一下，使得这一帧的x和y可以直接查询到上一帧的结果
    std::swap(m_misc, m_accColor);
}

void Denoiser::TemporalAccumulation(const Buffer2D<Float3> &curFilteredColor) {
    int height = curFilteredColor.m_height;
    int width = curFilteredColor.m_width;
#pragma omp parallel for
    for (int y = BORDER_PIXEL; y < height - BORDER_PIXEL; y++) {
        for (int x = BORDER_PIXEL; x < width - BORDER_PIXEL; x++) {
            // TODO: Exponential moving average
            float alpha = 0.2f;
            Float3 color = m_accColor(x, y);

            // Don't use detection.
            //if (m_valid(x, y)) {
            //    // TODO: Temporal clamp
            //    Float3 meanColor;
            //    Float3 varianceColor;
            //    CalcColorMeanAndVariance(curFilteredColor, x, y, 3, meanColor, varianceColor);
            //    color = Clamp(color, meanColor - varianceColor,
            //          meanColor + varianceColor);

            //    alpha = 0.2;
            //} else {
            //    // Trust current frame more than previous frame.
            //    alpha = 1.0;
            //}

             Float3 meanColor;
             Float3 varianceColor;
             CalcColorMeanAndVariance(curFilteredColor, x, y, 3, meanColor,
             varianceColor); 
             color = Clamp(color, meanColor - varianceColor,
                      meanColor + varianceColor);

            m_misc(x, y) = Lerp(color, curFilteredColor(x, y), alpha);
        }
    }
    // 当前过滤的帧保存到m_accColor
    std::swap(m_misc, m_accColor);
}

Buffer2D<Float3> Denoiser::Filter(const FrameInfo &frameInfo) {
    int height = frameInfo.m_beauty.m_height;
    int width = frameInfo.m_beauty.m_width;
    Buffer2D<Float3> filteredImage = CreateBuffer2D<Float3>(width, height);
    int kernelRadius = 16;
// Nextline lauch multiple thread
#pragma omp parallel for
    for (int y = BORDER_PIXEL; y < height - BORDER_PIXEL; y++) {
        for (int x = BORDER_PIXEL; x < width - BORDER_PIXEL; x++) {
            //std::cout << frameInfo.m_depth(x, y) << std::endl;  // box is 6 or 4
            // TODO: Joint bilateral filter
            // Find nearly pixel
            int lIx = std::max(x - kernelRadius, BORDER_PIXEL);
            int rIx = std::min(x + kernelRadius, width - BORDER_PIXEL - 1);
            int tIx = std::max(y - kernelRadius, BORDER_PIXEL);
            int bIx = std::min(y + kernelRadius, height - BORDER_PIXEL - 1);
            float sumOfWeight = 1.0f;
            Float3 sumOfWeightColor = frameInfo.m_beauty(x, y);

            Float3 variance(0.), mean;
            CalcColorMeanAndVariance(frameInfo.m_beauty, x, y, 3, mean, variance);

            for (int i=lIx; i <= rIx; i++) {
                for (int j=tIx; j <= bIx; j++) {
                    if (i == x && j == y)
                        continue;

                    // Distance
                    float dWeight = DistWeight(x, y, i, j, frameInfo);
                    //float dWeight = DistWeightSVGF(x, y, i, j, frameInfo);
                    // Color Distance
                    float cdWeight = ColorWeight(x, y, i, j, variance, frameInfo);
                    //float cdWeight = ColorWeightSVGF(x, y, i, j, variance, frameInfo);
                    // Depth Distance
                    float ddWeight = DepthWeight(x, y, i, j, frameInfo);
                    //float ddWeight = DepthWeightSVGF(x, y, i, j, frameInfo);
                    // Normal Distance
                    float ndWeightCoef = NormalWeight(x, y, i, j, frameInfo);
                    //float ndWeightCoef = NormalWeightSVGF(x, y, i, j, frameInfo);

                    float weight = dWeight + cdWeight + ddWeight + ndWeightCoef;

                    sumOfWeight += weight;
                    sumOfWeightColor = frameInfo.m_beauty(i, j) * weight +
                    sumOfWeightColor;
                }
            }
            
            filteredImage(x, y) = sumOfWeightColor / sumOfWeight;
        }
    }
    
    return filteredImage;
}

void Denoiser::Init(const FrameInfo &frameInfo, const Buffer2D<Float3> &filteredColor) {
    // m_accColor上一帧过滤的结果
    m_accColor.Copy(filteredColor);
    int height = m_accColor.m_height;
    int width = m_accColor.m_width;
    m_misc = CreateBuffer2D<Float3>(width, height);
    m_valid = CreateBuffer2D<bool>(width, height);
}

void Denoiser::Maintain(const FrameInfo &frameInfo) { m_preFrameInfo = frameInfo; }

Buffer2D<Float3> Denoiser::ProcessFrame(const FrameInfo &frameInfo) {
    // Filter current frame
    Buffer2D<Float3> filteredColor;
    filteredColor = Filter(frameInfo);

    // Reproject previous frame color to current
    if (m_useTemportal) {
        Reprojection(frameInfo);
        TemporalAccumulation(filteredColor);
    } else {
        Init(frameInfo, filteredColor);
    }

    // Maintain
    Maintain(frameInfo);
    if (!m_useTemportal) {
        m_useTemportal = true;
    }
    return m_accColor;
}
