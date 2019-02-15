//
//  RubberRangeThumb.swift
//  rubberRangePickerSample
//
//  Created by Anton Skopin on 13/02/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class RubberRangeThumb: UIView {
    override var tintColor: UIColor! {
        didSet {
            fillColor = tintColor.lighter(by: 0.5)
            content?.strokeColor = tintColor.cgColor
            content?.fillColor = isHighLighted ? fillColor.cgColor : UIColor.white.cgColor
        }
    }
    var fillColor: UIColor = .white
    
    var isHighLighted: Bool = false {
        didSet {
            content?.fillColor = isHighLighted ? fillColor.cgColor : UIColor.white.cgColor
        }
    }
    
    var content: CAShapeLayer?
    func drawContent() {
        let contentLayer = CAShapeLayer()
        contentLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        contentLayer.fillColor = fillColor.cgColor
        contentLayer.strokeColor = tintColor.cgColor
        contentLayer.lineWidth = 2.0
        layer.addSublayer(contentLayer)
        content?.removeFromSuperlayer()
        content = contentLayer
    }
    
    override func layoutSubviews() {
        drawContent()
    }
}
