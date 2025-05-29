[toc]

# 4. 不带颜色的KullaConty近似

​	微表面模型的一个问题是**能量损失**，这个问题是**由于G项导致的，因为微表面自遮挡的光线被忽略了，正常是在多次弹射后离开**

* KullaConty近似的原理：

1. 假设**菲涅尔项为1**，即R0为1，**意味着光全反射出去，没有能量损失**
2. 假设**环境光处处相等，且为1**
3. 假设材质各向同性

那么我们很自然的可以遇见，**任意出射方向的radiant也应该是1**

那么能量损失为
$$
1 - E(u_o) = 1-\int 1 * f(i,o)cos\theta_idw
$$
根据GGX重要性采样得出的结论，蒙特卡洛积分项为
$$
\frac{G(i,o,h)(o\cdot h)}{(o\cdot n)(n\cdot h)}
$$

* 根据roughness和出射方向o可以对$E(u_o)$进行预计算

* **现在的重点就是构建一个brdf，使得其积分等于**$1-E(u_o)$

构建的brdf如下
$$
f = \frac{(1-E(u_o))(1-E(u_i))}{\pi(1-E_{avg})} \\
$$
推导
$$
\int_0^{2\pi}\int_0^1\frac{(1-E(u_o))(1-E(u_i))}{\pi(1-E_{avg})}u_i{du}d\phi \\
= 2\pi\int_0^1\frac{(1-E(u_o))(1-E(u_i))}{\pi(1-E_{avg})}u_i{du} \\
= 2\frac{1-E(u_o)}{(1-E_{avg})}\int_0^1(1-E(u_i))u_idu \\
= 2\frac{1-E(u_o)}{(1-E_{avg})}\int_0^1(1-E(u_i))du*\int_0^1u_idu \\
= \frac{1-E(u_o)}{(1-E_{avg})}(1-E_{avg}) \\
= 1-E(u_o)
$$
其中$E_{avg}$计算公式如下
$$
E_{avg} = 2\int_0^1E(u)udu
$$
于是可以对$E_{avg}$进行预计算

最后只需要在原本的brdf中加上上面的项即可。



# 5. 带颜色的KullaConty

​	带颜色的微表面需要考虑本身由于吸收造成的能量损失。

* 平均菲涅尔项

平均菲涅尔项告诉我们无论入射方向是哪里，反射率都是相等的（平均的）。

一次反射的能量$L = F_{avg}F_{avg}$

二次反射的能量$ L=F_{avg}(1-E_{avg})*F_{avg}E_{avg}$

k次反射的能量$L=F^k_{avg}(1-E_{avg})^k*F_{avg}E_{avg}$

其中，$F_{avg}$表示入射光有多少能量被反射，这个值决定了**正确的能量损失**是多少；

$E_{avg}$表示被反射的光中有多少是**直接反射出去被看到的**，那么会**经历多次bound的能量**便是$F_{avg}(1-E_{avg})$

将1到k次的能量累加起来，得到一个级数
$$
F_{add} = \frac{F_{avg}E_{avg}}{1-F_{avg}(1-E_{avg})}
$$
将这个数乘以上面的brdf即可。

至于平均菲涅尔项怎么计算

参考https://blog.selfshadow.com/publications/s2017-shading-course/imageworks/s2017_pbs_imageworks_slides_v2.pdf