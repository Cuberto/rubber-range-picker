//
//  RubberRangePicker.swift
//  rubberRangePickerSample
//
//  Created by Anton Skopin on 13/02/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

@IBDesignable open class RubberRangePicker: UIControl {
    
    public enum ElasticBehavior {
        case linear
        case cubic
    }
    
    open var elasticBehavior: ElasticBehavior = .cubic {
        didSet {
            trackLayer.behavior = elasticBehavior
        }
    }
    
    @IBInspectable open var damping: CGFloat = 0.5
    @IBInspectable open var elasticity: CGFloat = 0.5
    @IBInspectable open var constraintStretch: Bool = true
    @IBInspectable open var stretchRange: CGFloat = 30
    @IBInspectable open var animationSpeed: CGFloat = 1.0
    
    open override var tintColor: UIColor! {
        didSet {
            trackLayer.innerColor = tintColor
            trackLayer.setNeedsDisplay()
            lowerThumb.tintColor = tintColor
            upperThumb.tintColor = tintColor
        }
    }
    
    open var lineColor: UIColor! = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.9294117647, alpha: 1) {
        didSet {
            trackLayer.outerColor = lineColor
            trackLayer.setNeedsDisplay()
        }
    }
    
    open var thumbSize: CGFloat = 40.0 {
        didSet {
            trackLayer.margin = thumbSize/2.0
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: thumbSize * 6, height: thumbSize + 2)
    }
    
    
    private var _lowerValue: Double = 0.0
    private var _upperValue: Double = 1.0
    
    @IBInspectable public var minimumValue: Double = 0.0 {
        didSet {
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
        }
    }
    @IBInspectable public var maximumValue: Double = 1.0 {
        didSet {
            if maximumValue < minimumValue  {
                minimumValue = maximumValue
            }
        }
    }
    
    @IBInspectable public var lowerValue: Double {
        get {
            return _lowerValue
        }
        set {
            _lowerValue = max(minimumValue, min(maximumValue, newValue))
            if _lowerValue > upperValue {
                upperValue = _lowerValue
            }
        }
    }
    @IBInspectable public var upperValue: Double {
        get {
            return _upperValue
        }
        set {
            _upperValue = max(minimumValue, min(maximumValue, newValue))
            if _upperValue < lowerValue {
                lowerValue = _upperValue
            }
        }
    }
    
    
    private var trackLayer = RubberTrackLayer()
    private var lowerThumb = RubberRangeThumb()
    private var upperThumb = RubberRangeThumb()
    private var previousLocation = CGPoint()
    
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(screenUpdate))
    
    private var movingLower: Bool = false
    private var movingUpper: Bool = false
    
    private var lowerAnimationStart: CFTimeInterval?
    private var lowerStartOffset: CGFloat?
    private var upperAnimationStart: CFTimeInterval?
    private var upperStartOffset: CGFloat?
    
    private var vertOffset: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override open func prepareForInterfaceBuilder() {
        configure()
        screenUpdate()
        updateTrackLayer()
    }
    
    private func configure() {
        tintColor = #colorLiteral(red: 0.168627451, green: 0.6745098039, blue: 0.9882352941, alpha: 1)
        trackLayer.innerColor = tintColor
        trackLayer.outerColor = lineColor
        trackLayer.behavior = elasticBehavior
        lowerThumb.isUserInteractionEnabled = false
        upperThumb.isUserInteractionEnabled = false
        layer.addSublayer(trackLayer)
        addSubview(lowerThumb)
        addSubview(upperThumb)
        lowerThumb.frame = CGRect(x: 0, y: (bounds.height - thumbSize) / 2.0,
                                  width: thumbSize, height: thumbSize)
        upperThumb.frame = CGRect(x: bounds.width - thumbSize, y: (bounds.height - thumbSize) / 2.0,
                                  width: thumbSize, height: thumbSize)
        displayLink.add(to: .current, forMode: .common)
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        vertOffset = 0
        let location = touch.location(in: self)
        if lowerThumb.frame.contains(location) {
            movingLower = true
            lowerAnimationStart = nil
            lowerStartOffset = nil
        } else if upperThumb.frame.contains(location) {
            movingUpper = true
            upperAnimationStart = nil
            upperStartOffset = nil
        }
        return movingLower || movingUpper
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbSize * 2)
        previousLocation = location
        if movingLower {
            lowerValue = bound(value: lowerValue + deltaValue, toLowerValue: minimumValue, upperValue: maximumValue)
            upperValue = max(upperValue, lowerValue)
        } else if movingUpper {
            upperValue = bound(value: upperValue + deltaValue, toLowerValue: minimumValue, upperValue: maximumValue)
            lowerValue = min(upperValue, lowerValue)
        }
        
        let touchOffset = (location.y - bounds.height/2.0)
        let touchOffsetVal = abs(touchOffset)
        let sign: CGFloat = touchOffset.sign == .minus ? -1 : 1
        var maxVal: CGFloat = stretchRange
        if (constraintStretch){
            maxVal = min(maxVal, (upperOffset - lowerOffset)/2.0)
            if movingLower {
                maxVal = min(maxVal, lowerOffset/2.0)
            }
            if movingUpper {
                maxVal = min(maxVal, (bounds.width - upperOffset)/2.0)
            }
        }
        let offsetVal = (maxVal - 1/(touchOffsetVal * pow(48, -(1.9 + 0.6 * elasticity)) + 1/maxVal))
        vertOffset = sign * min(offsetVal, touchOffsetVal)
        
        sendActions(for: .valueChanged)
        return true
    }
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        CACurrentMediaTime()
        if (movingLower) {
            lowerAnimationStart = CACurrentMediaTime()
            lowerStartOffset = vertOffset
        }
        if (movingUpper) {
            upperAnimationStart = CACurrentMediaTime()
            upperStartOffset = vertOffset
        }
        movingLower = false
        movingUpper = false
    }
    
    private var lowerOffset: CGFloat {
        return (bounds.width - thumbSize * 2) * CGFloat((lowerValue - minimumValue) / (maximumValue - minimumValue))
    }
    
    private var upperOffset: CGFloat {
        return (bounds.width - thumbSize * 2) * CGFloat((upperValue - minimumValue) / (maximumValue - minimumValue)) + thumbSize
    }
    
    private func bound(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    private func position(for value: Double) -> CGFloat {
        return (bounds.width - thumbSize) * CGFloat((value - minimumValue) / (maximumValue - minimumValue))
    }
    
    @objc private func screenUpdate() {
        lowerThumb.isHighLighted = movingLower
        upperThumb.isHighLighted = movingUpper
        
        let timeMultiplier: CGFloat = 2.5 * animationSpeed
        
        var lowerVertOffset: CGFloat = (movingLower ? vertOffset : 0)
        if !movingLower,
            let lowerAnimationStart = lowerAnimationStart,
            let lowerStartOffset = lowerStartOffset {
            let elapsedTime = CGFloat(CACurrentMediaTime() - lowerAnimationStart) * timeMultiplier
            lowerVertOffset = springCoordinate(forTime: elapsedTime, offset: lowerStartOffset)
        }
        var upperVertOffset: CGFloat = (movingUpper ? vertOffset : 0)
        if !movingLower,
            let upperAnimationStart = upperAnimationStart,
            let upperStartOffset = upperStartOffset {
            let elapsedTime = CGFloat(CACurrentMediaTime() - upperAnimationStart) * timeMultiplier
            upperVertOffset = springCoordinate(forTime: elapsedTime, offset: upperStartOffset)
        }
        
        lowerThumb.frame = CGRect(x: lowerOffset,
                                  y: (bounds.height - thumbSize)/2.0 + lowerVertOffset,
                                  width: thumbSize, height: thumbSize)
        
        upperThumb.frame = CGRect(x: upperOffset,
                                  y: (bounds.height - thumbSize)/2.0 + upperVertOffset,
                                  width: thumbSize, height: thumbSize)
        updateTrackLayer()
        
    }
    
    private func springCoordinate(forTime time: CGFloat, offset: CGFloat) -> CGFloat {
        let A: CGFloat = offset
        let r: CGFloat = 40
        let m: CGFloat = 6
        let beta: CGFloat = r/(2*m)
        let k: CGFloat = 20 + 100 * damping
        let omega0: CGFloat = k/m
        let omega: CGFloat = pow(-pow(beta,2)+pow(omega0,2), 0.5)
        
        return A * exp(-beta * time) * cos(omega * time)
    }
    
    private func updateTrackLayer() {
        trackLayer.frame = bounds
        trackLayer.lowerOffset = lowerThumb.frame.midX
        trackLayer.upperOffset = upperThumb.frame.midX
        trackLayer.lowerVertOffset = lowerThumb.frame.midY - bounds.height/2.0
        trackLayer.upperVertOffset = upperThumb.frame.midY - bounds.height/2.0
        trackLayer.redraw()
    }
    
}
