//
//  RubberTrackLayer.swift
//  rubberRangePickerSample
//
//  Created by Anton Skopin on 13/02/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class RubberTrackLayer: CALayer {
    
    var behavior: RubberRangePicker.ElasticBehavior = .linear
    var margin: CGFloat = 0
    var innerColor: UIColor = .blue {
        didSet {
            secondSegment.strokeColor = innerColor.cgColor
        }
    }
    var outerColor: UIColor = .lightGray {
        didSet {
            firstSegment.strokeColor = outerColor.cgColor
            thirdSegment.strokeColor = outerColor.cgColor
        }
    }
    
    var lowerOffset: CGFloat = 0
    var upperOffset: CGFloat = 1.0
    
    var lowerVertOffset: CGFloat = 0
    var upperVertOffset: CGFloat = 0
    
    lazy var firstSegment: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = innerColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        self.addSublayer(layer)
        return layer
    }()
    lazy var secondSegment: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = outerColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 2.0
        self.addSublayer(layer)
        return layer
    }()
    lazy var thirdSegment: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = innerColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        self.addSublayer(layer)
        return layer
    }()
    
    func redraw() {
        firstSegment.frame = self.bounds
        secondSegment.frame = self.bounds
        thirdSegment.frame = self.bounds
        let diff = upperOffset - lowerOffset
        
        let pt1 = CGPoint(x: margin, y: bounds.midY)
        let pt2 = CGPoint(x: margin + lowerOffset, y: bounds.midY + lowerVertOffset)
        let pt3 = CGPoint(x: margin + upperOffset, y: bounds.midY + upperVertOffset)
        let pt4 = CGPoint(x: bounds.maxX - margin, y: bounds.midY)
        
        let firstPath = UIBezierPath()
        let secondPath = UIBezierPath()
        let thirdPath = UIBezierPath()
        firstPath.move(to: pt1)
        secondPath.move(to: pt2)
        thirdPath.move(to: pt3)
        switch behavior {
        case .linear:
            firstPath.addLine(to: pt2)
            secondPath.addLine(to: pt3)
            thirdPath.addLine(to: pt4)
        case .cubic:
            firstPath.addCurve(to: pt2,
                               controlPoint1: pt1.offsetBy(dx: lowerOffset/2.0),
                               controlPoint2: pt2.offsetBy(dx: -lowerOffset/2.0))
            secondPath.addCurve(to: pt3,
                                controlPoint1: pt2.offsetBy(dx: diff/2.0),
                                controlPoint2: pt3.offsetBy(dx: -diff/2.0))
            let controlOffset = (bounds.width - margin * 2 - upperOffset)/2.0
            thirdPath.addCurve(to: pt4,
                               controlPoint1: pt3.offsetBy(dx: controlOffset),
                               controlPoint2: pt4.offsetBy(dx: -controlOffset))
        }
        firstSegment.path = firstPath.cgPath
        secondSegment.path = secondPath.cgPath
        thirdSegment.path = thirdPath.cgPath
    }
}
