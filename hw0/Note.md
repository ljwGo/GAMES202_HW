[toc]

# 0. WebGL的使用

跟随assignment的文件指导就能够加载obj了。

WebGL简单理解为基于Web应用GLSL着色器语法的实现



# 1. 遇到的问题

期间遇到了一个异步导致文件资源未加载的问题。

具体参考

[作业0 结果不稳定，有时模型显示不全 – 计算机图形学与混合现实在线平台 (games-cn.org)](https://games-cn.org/forums/topic/zuoye0-jieguobuwendingyoushimoxingxianshibuquan/)

**解决方法是**使用预加载

添加标签

<link rel="preload" href="/assets/mary/MC003_Kozakura_Mari.png" as="image" type="image/png" crossorigin/>