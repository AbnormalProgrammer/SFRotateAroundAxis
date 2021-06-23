//
//  HomogeneousMatrix.swift
//  LovelyPet
//
//  Created by Stroman on 2021/6/3.
//

import GLKit

extension CGFloat {
    func toFloat() -> Float {
        return Float.init(self)
    }
}

extension Float {
    func toCGFloat() -> CGFloat {
        return CGFloat.init(self)
    }
}

extension GLKMatrix4 {
    /// 绕三维空间内的任意轴进行旋转
    /// - Parameters:
    ///   - anyPoint: 待旋转的任意点坐标
    ///   - axisStart: 旋转轴的起点
    ///   - axisEnd: 旋转轴的终点
    ///   - radian: 旋转的弧度
    /// - Returns: 旋转后的点坐标
    static func rotateAroundAnyAxis(_ anyPoint:GLKVector3,_ axisStart:GLKVector3,_ axisEnd:GLKVector3,_ radian:CGFloat) -> GLKVector3 {
        let originalPoint:GLKVector3 = GLKVector3Subtract(anyPoint, axisStart)
        let normalAxis:GLKVector3 = GLKVector3Subtract(axisEnd, axisStart)
        let result:GLKVector3 = GLKMatrix4.rotateAroundNormalAxis(originalPoint, normalAxis, radian)
        return GLKVector3Add(result, axisStart)
    }
    /// 在归一化空间内绕任意轴旋转
    /// 即，旋转轴的原点在坐标原点。
    /// 各个轴的范围在[-1,1]之内。
    /// - Parameters:
    ///   - inputPoint: 待旋转的点坐标
    ///   - axis: 旋转轴的向量
    ///   - radians: 旋转的弧度
    /// - Returns: 旋转后的点坐标
    static func rotateAroundNormalAxis(_ inputPoint:GLKVector3,_ axis:GLKVector3,_ radian:CGFloat) -> GLKVector3 {
        guard axis.model() > 0 && radian != 0 else {
            return inputPoint
        }
        let yzLength:Float = sqrtf(powf(axis.y, 2) + powf(axis.z, 2))
        let originalVector4:GLKVector4 = GLKVector4MakeWithVector3(inputPoint, 0)
        let vectorLength:Float = axis.model()
        /*首先绕X轴旋转到XOY平面上去*/
        var rotateXMatrix:GLKMatrix4 = GLKMatrix4Identity
        if yzLength > 0 {
            let cos0:Float = axis.y / yzLength
            let sin0:Float = -axis.z / yzLength
            rotateXMatrix = GLKMatrix4.xRotationMatrix(sin0, cos0)
        }
        /*然后绕Z轴旋转到Y轴上面去*/
        let cos1:Float = sqrtf(powf(axis.y, 2) + powf(axis.z, 2)) / vectorLength
        let sin1:Float = axis.x / vectorLength
        let rotateZMatrix:GLKMatrix4 = GLKMatrix4.zRotationMatrix(sin1, cos1)
        /*此时正式绕Y轴旋转*/
        let cos2:Float = cos(radian).toFloat()
        let sin2:Float = sin(radian).toFloat()
        let rotateYMatrix:GLKMatrix4 = GLKMatrix4.yRotationMatrix(sin2, cos2)
        /*绕着Z旋转，转到原来在XOY平面上的位置*/
        let cos3:Float = cos1
        let sin3:Float = -sin1
        let rotateReverseZMatrix:GLKMatrix4 = GLKMatrix4.zRotationMatrix(sin3, cos3)
        /*绕X轴旋转，转回原来的位置*/
        var rotateReverseXMatrix:GLKMatrix4 = GLKMatrix4Identity
        if yzLength > 0 {
            let cos4:Float = axis.y / yzLength
            let sin4:Float = axis.z / yzLength
            rotateReverseXMatrix = GLKMatrix4.xRotationMatrix(sin4, cos4)
        }
        var tempMatrix:GLKMatrix4 = GLKMatrix4Identity
        tempMatrix = tempMatrix.multiplyMatrix(rotateReverseXMatrix)
        tempMatrix = tempMatrix.multiplyMatrix(rotateReverseZMatrix)
        tempMatrix = tempMatrix.multiplyMatrix(rotateYMatrix)
        tempMatrix = tempMatrix.multiplyMatrix(rotateZMatrix)
        tempMatrix = tempMatrix.multiplyMatrix(rotateXMatrix)
        let tempVector4:GLKVector4 = tempMatrix.multiplyVector(originalVector4)
        return GLKVector3Make(tempVector4.x, tempVector4.y, tempVector4.z)
    }
    
    /// 矩阵乘法，使用点语法更加方便
    /// - Parameter matrix: 输入的矩阵
    /// - Returns: 结果矩阵
    func multiplyMatrix(_ matrix:GLKMatrix4) -> GLKMatrix4 {
        return GLKMatrix4Multiply(self, matrix)
    }
    
    /// 右乘4维向量
    /// - Parameter vector: 待乘的向量
    /// - Returns: 结果
    func multiplyVector(_ vector:GLKVector4) -> GLKVector4 {
        return GLKMatrix4MultiplyVector4(self, vector)
    }
    
    /// 输入正余弦的值得到绕X轴旋转的矩阵
    /// - Parameters:
    ///   - sinValue: 正弦值
    ///   - cosValue: 余弦值
    /// - Returns: 旋转矩阵
    static func xRotationMatrix(_ sinValue:Float,_ cosValue:Float) -> GLKMatrix4 {
        return GLKMatrix4MakeWithColumns(GLKVector4Make(1, 0, 0, 0),
                                         GLKVector4Make(0, cosValue, sinValue, 0),
                                         GLKVector4Make(0, -sinValue, cosValue, 0),
                                         GLKVector4Make(0, 0, 0, 1))
    }
    
    /// 输入正余弦的值得到绕Y轴旋转的矩阵
    /// - Parameters:
    ///   - sinValue: 正弦值
    ///   - cosValue: 余弦值
    /// - Returns: 旋转矩阵
    static func yRotationMatrix(_ sinValue:Float,_ cosValue:Float) -> GLKMatrix4 {
        return GLKMatrix4MakeWithColumns(GLKVector4Make(cosValue, 0, -sinValue, 0),
                                         GLKVector4Make(0, 1, 0, 0),
                                         GLKVector4Make(sinValue, 0, cosValue, 0),
                                         GLKVector4Make(0, 0, 0, 1))
    }
    
    /// 输入正余弦的值得到绕Z轴旋转的矩阵
    /// - Parameters:
    ///   - sinValue: 正弦值
    ///   - cosValue: 余弦值
    /// - Returns: 旋转矩阵
    static func zRotationMatrix(_ sinValue:Float,_ cosValue:Float) -> GLKMatrix4 {
        return GLKMatrix4MakeWithColumns(GLKVector4Make(cosValue, sinValue, 0, 0),
                                         GLKVector4Make(-sinValue, cosValue, 0, 0),
                                         GLKVector4Make(0, 0, 1, 0),
                                         GLKVector4Make(0, 0, 0, 1))
    }
}

extension GLKVector3 {
    func model() -> Float {
        return GLKVector3Length(self)
    }
}
