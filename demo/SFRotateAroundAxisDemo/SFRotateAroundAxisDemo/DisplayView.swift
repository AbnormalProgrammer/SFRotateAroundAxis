//
//  DisplayView.swift
//  SFRotateAroundAxisDemo
//
//  Created by Stroman on 2021/6/23.
//

import UIKit
import GLKit

class DisplayView: UIImageView {
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.customInitilizer()
        self.installUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.atuoRotationTimer?.invalidate()
        self.atuoRotationTimer = nil
        print("\(type(of: self))释放了")
    }
    // MARK: - custom methods
    private func customInitilizer() -> Void {
        self.backgroundColor = UIColor.blue
        self.contentMode = .center
        self.image = UIImage.init(systemName: "sun.max", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 200))?.withTintColor(UIColor.yellow, renderingMode: .alwaysOriginal)
        self.atuoRotationTimer = CADisplayLink.init(target: self, selector: #selector(rotationAction))
        self.atuoRotationTimer?.add(to: .current, forMode: .default)
    }
    
    private func installUI() -> Void {
        self.addSubview(self.earthView)
        self.currentNormLocation = GLKVector3Make(-0.7, 0, 0)
        /*通过终点减起点获取旋转轴向量，主要是为了让你看明白思想*/
        self.axis = GLKVector3Make(0, -100, 30)
        self.earthView.center = CGPoint.init(x: self.currentNormLocation!.x.toCGFloat() * self.bounds.size.width / 2 + self.bounds.size.width / 2, y: self.currentNormLocation!.y.toCGFloat() * self.bounds.size.height / 2 + self.bounds.size.height / 2)
    }
    // MARK: - public interfaces
    // MARK: - actions
    @objc private func rotationAction() -> Void {
        self.currentNormLocation = GLKMatrix4.rotateAroundAxis(self.currentNormLocation!, self.axis!, 0.02)
        self.earthView.center = CGPoint.init(x: self.currentNormLocation!.x.toCGFloat() * self.bounds.size.width / 2 + self.bounds.size.width / 2, y: self.currentNormLocation!.y.toCGFloat() * self.bounds.size.height / 2 + self.bounds.size.height / 2)
        /*这里利用Z坐标做一些效果*/
        /*远小近大的效果*/
        let scope:CGFloat = 15
        self.earthView.bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 30 + scope * self.currentNormLocation!.z.toCGFloat(), height: 30 + scope * self.currentNormLocation!.z.toCGFloat()))
        /*远暗近明的效果*/
        self.earthView.alpha = 0.7 + 0.5 * self.currentNormLocation!.z.toCGFloat()
    }
    // MARK: - accessors
    /*角速度，弧度*/
    private let palstance:CGFloat = 0.02
    private var axis:GLKVector3?
    private var currentNormLocation:GLKVector3?
    private var atuoRotationTimer:CADisplayLink?
    lazy private var earthView:UIImageView = {
        let result:UIImageView = UIImageView.init()
        result.bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 30, height: 30))
        result.contentMode = .scaleToFill
        result.image = UIImage.init(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 50))?.withTintColor(UIColor.red, renderingMode: .alwaysOriginal)
        return result
    }()
    // MARK: - delegates
}
