#pragma once

#define NOMINMAX
#include <string>

#include "filesystem/path.h"

#include "util/image.h"
#include "util/mathutil.h"

struct FrameInfo {
  public:
    Buffer2D<Float3> m_beauty;
    Buffer2D<float> m_depth;
    Buffer2D<Float3> m_normal;
    Buffer2D<Float3> m_position;
    Buffer2D<float> m_id;
    std::vector<Matrix4x4> m_matrix;
};

class Denoiser {
  public:
    float DistWeightSVGF(int x, int y, int i, int j, const FrameInfo &frameInfo);
    float NormalWeightSVGF(int x, int y, int i, int j,
                           const FrameInfo &frameInfo);
    float DepthWeightSVGF(int x, int y, int i, int j,
                          const FrameInfo &frameInfo);
    float ColorWeightSVGF(int x, int y, int i, int j, const Float3 &variance,
                          const FrameInfo &frameInfo);
    float DistWeight(int x, int y, int i, int j, const FrameInfo &frameInfo);
    float NormalWeight(int x, int y, int i, int j, const FrameInfo &frameInfo);
    float DepthWeight(int x, int y, int i, int j, const FrameInfo &frameInfo);
    float ColorWeight(int x, int y, int i, int j, const Float3 &varianceColor,
                      const FrameInfo &frameInfo);
    Denoiser();

    void CalcColorMeanAndVariance(const Buffer2D<Float3> &colorBuffer, int x, int y,
                                  int kernelSize, Float3 &mean,
                                  Float3 &variance);

    void Init(const FrameInfo &frameInfo, const Buffer2D<Float3> &filteredColor);
    void Maintain(const FrameInfo &frameInfo);

    void Reprojection(const FrameInfo &frameInfo);
    void TemporalAccumulation(const Buffer2D<Float3> &curFilteredColor);
    Buffer2D<Float3> Filter(const FrameInfo &frameInfo);

    Buffer2D<Float3> ProcessFrame(const FrameInfo &frameInfo);

  public:
    FrameInfo m_preFrameInfo;
    Buffer2D<Float3> m_accColor;
    Buffer2D<Float3> m_misc;
    Buffer2D<bool> m_valid;
    bool m_useTemportal;

    float m_alpha = 0.2f;
    float m_sigmaPlane = .1f;
    float m_sigmaColor = .01f;
    float m_sigmaNormal = .1f;
    float m_sigmaCoord = .1f;
    float m_svgfSigmaCoord = 8.0f;  // or 5. bigger more blur
    float m_svgfSigmaColor = 0.4f;  // bigger more blur
    float m_svgfSigmaNormal = 1.f;  // bigger more sharp
    float m_svgfSigmaDepth = 0.2f;  // bigger more blur
    float m_colorBoxK = 1.0f;
};