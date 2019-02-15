//
//  Extensions.swift
//  rubberRangePickerSample
//
//  Created by Anton Skopin on 13/02/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat = 0, dy: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension UIColor {
    func lighter(by lighterPercent: CGFloat) -> UIColor {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        return UIColor(red: min(1.0, (fRed + 1.0) * lighterPercent),
                       green: min(1.0, (fGreen + 1.0) * lighterPercent),
                       blue: min(1.0, (fBlue + 1.0) * lighterPercent), alpha: fAlpha)
    }
}


