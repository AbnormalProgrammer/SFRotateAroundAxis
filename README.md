# 绕任意轴旋转(SFRotateAroundAxis)
这是个让UIKit空间内的任意点绕任意轴旋转的扩展接口。
## 示例
![示例](https://github.com/AbnormalProgrammer/SFRotateAroundAxis/raw/main/resources/示例.gif)
## 它是什么？
它是个扩展，主要是扩展了`GLKMatrix4`，是它的类方法。另外还包含了几个辅助性的相关扩展接口。
## 它有什么用？
它能够让`UIKit`坐标系空间中的任意点，让任意轴旋转一定的弧度。可以用于UIKit上面的视图动画等需求。
## 它的需求背景是什么？
在iOS中不乏绕坐标轴旋转的变换矩阵，但是绕任意轴旋转的矩阵却没有，聪明的程序员同学虽然可以自己通过各种变换来达到目的，却会花费很多宝贵的时间，在这里我只是想给各位程序员同学提供一种快速达到目的的手段而已。
## 行为表现
该接口是基于UIKit左手坐标系实现，它的正方向是左手大拇指指向坐标轴正向的情况下，四指所指的方向，即，顺时针方向。顺时针方向是从坐标轴正向看向坐标轴负向得到的。在给定旋转弧度数值为正的情况下点坐标会绕坐标轴进行顺时针旋转。在UIKit坐标系中X轴正向指向右，Y轴正向向下，Z轴正向垂直于屏幕指向外。
## 原理
单位空间指的是3个坐标轴范围全部是[-1,1]的3维空间。
旋转轴向量的起点是坐标原点，旋转轴的终点是空间内任意点，但是不能与起点重合，另外，终点也不一定必须是单位空间内的点。首先把旋转轴旋转到与Y轴负向重合，然后旋转输入的角度，最后把旋转轴恢复到原来的位置。这种旋转轴的变换用的是计算机图形学中的矩阵变换，有兴趣的同学可以去深入了解一下绕任意轴旋转相关的知识。之所以让旋转轴与Y轴负向重合，是因为这符合一般感觉。
## 如何使用？
该扩展涉及到了2个接口，分别是`static func rotateAroundAnyAxis(_ anyPoint:GLKVector3,_ axisStart:GLKVector3,_ axisEnd:GLKVector3,_ radian:CGFloat) -> GLKVector3`和`static func rotateAroundNormalAxis(_ inputPoint:GLKVector3,_ axis:GLKVector3,_ radian:CGFloat) -> GLKVector3`。

`static func rotateAroundAnyAxis(_ anyPoint:GLKVector3,_ axisStart:GLKVector3,_ axisEnd:GLKVector3,_ radian:CGFloat) -> GLKVector3`，给定UIKit三维空间中任何一个点坐标，旋转轴的起点，旋转轴的终点，旋转的弧度，就可以计算出该点绕旋转轴旋转以后的点坐标。具体用法可以参考`DisplayView.swift`中的`@objc private func rotationAction() -> Void`方法  

`static func rotateAroundNormalAxis(_ inputPoint:GLKVector3,_ axis:GLKVector3,_ radian:CGFloat) -> GLKVector3`一般用于单位空间坐标系内的旋转，即，你设定的空间，在归一化以后即为从-1到1的空间，坐标系的原点是旋转轴的起点。  调用的方式为  
```
GLKMatrix4.rotateAroundNormalAxis(self.currentLocation!, GLKVector3Make(0, -1, 0), 0.02)
```
## 适用环境
iOS 14.5及以上
swift 5.0
XCode 12
## 联系方式
我的profile里面有联系方式
## 许可证
本控件遵循MIT许可，详情请见[LICENSE](https://github.com/AbnormalProgrammer/SFRotateAroundAxis/blob/main/LICENSE)。
