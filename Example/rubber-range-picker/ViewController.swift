//
//  ViewController.swift
//  rubber-range-picker
//
//  Created by Anton Skopin on 02/15/2019.
//  Copyright (c) 2019 Anton Skopin. All rights reserved.
//

import UIKit
import rubber_range_picker

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleSlider: RubberRangePicker!
    @IBOutlet weak var lblValues: UILabel!
    
    @IBOutlet weak var behaviorSelector: UISegmentedControl!
    @IBOutlet weak var lblDamping: UILabel!
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var lblElasticity: UILabel!
    @IBOutlet weak var elasticitySlider: UISlider!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var swtConstraintStretch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateState()
        sliderUpdated()
    }
    
    @IBAction func updateState() {
        lblDamping.text = String(format:"damping: %.1f", dampingSlider.value)
        lblElasticity.text = String(format:"elasticity: %.1f", elasticitySlider.value)
        lblHeight.text = "stretchRange: \(ceil(heightSlider.value))"
        lblSpeed.text = String(format:"animationSpeed: %.1f", speedSlider.value)
        
        sampleSlider.elasticBehavior = behaviorSelector.selectedSegmentIndex == 0 ? .cubic : .linear
        sampleSlider.damping = CGFloat(dampingSlider.value)
        sampleSlider.elasticity = CGFloat(elasticitySlider.value)
        sampleSlider.constraintStretch = swtConstraintStretch.isOn
        sampleSlider.stretchRange = CGFloat(heightSlider.value)
        sampleSlider.animationSpeed = CGFloat(speedSlider.value)
        view.layoutIfNeeded()
    }
    
    @IBAction func sliderUpdated() {
        lblValues.text = String(format:"Selected values: %.1f - %.1f", sampleSlider.lowerValue, sampleSlider.upperValue)
    }
    
}

