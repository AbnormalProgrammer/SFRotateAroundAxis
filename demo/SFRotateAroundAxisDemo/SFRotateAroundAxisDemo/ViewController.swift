//
//  ViewController.swift
//  SFRotateAroundAxisDemo
//
//  Created by Stroman on 2021/6/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let display:DisplayView = DisplayView.init(frame: AVMakeRect(aspectRatio: CGSize.init(width: 1, height: 1), insideRect: self.view.bounds))
        self.view.addSubview(display)
        display.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.init(item: display, attribute: .width, relatedBy: .equal, toItem: display, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: display, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: min(self.view.bounds.width, self.view.bounds.height)).isActive = true
        NSLayoutConstraint.init(item: display, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: display, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        // Do any additional setup after loading the view.
    }
}

