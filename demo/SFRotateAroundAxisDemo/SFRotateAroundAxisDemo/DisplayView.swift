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
        self.currentLocation = GLKVector3Make(self.bounds.width.toFloat() / 7, self.bounds.height.toFloat() / 2, 0)
        self.earthView.center = CGPoint.init(x: self.currentLocation!.x.toCGFloat(), y: self.currentLocation!.y.toCGFloat())
    }
    // MARK: - public interfaces
    // MARK: - actions
    @objc private func rotationAction() -> Void {
        self.currentLocation = GLKMatrix4.rotateAroundAnyAxis(self.currentLocation!, GLKVector3Make(self.bounds.width.toFloat() / 2, self.bounds.height.toFloat() / 2, 0), GLKVector3Make(self.bounds.width.toFloat() / 2, self.bounds.height.toFloat() / 2 - 100, 30), self.palstance)
        self.earthView.center = CGPoint.init(x: self.currentLocation!.x.toCGFloat(), y: self.currentLocation!.y.toCGFloat())
        /*这里还利用Z坐标做一些效果，不过这里就不写了。*/
    }
    // MARK: - accessors
    /*角速度，弧度*/
    private let palstance:CGFloat = 0.02
    private var currentLocation:GLKVector3?
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
