//
//  MukRingView.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/24/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

@IBDesignable
class MukRingView: UIView {

    // MARK: Variables
    var mukRingColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    var mukRatio: Float = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Draw Rect
    override func draw(_ rect: CGRect) {
        let mukLineWidth = 0.1 * bounds.width
        
        let mukCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let mukRadius = (bounds.width - mukLineWidth) * 0.5
        let mukStart = CGFloat.pi * -0.5
        let mukEnd = (CGFloat.pi * -0.5) + (CGFloat.pi * 2.0 * CGFloat(mukRatio))
        
        // Path For Darker Ring
        let mukPath = UIBezierPath(arcCenter: mukCenter, radius: mukRadius, startAngle: mukStart, endAngle: mukEnd, clockwise: true)
        mukPath.lineWidth = mukLineWidth
        UIColor.clear.setFill()
        mukRingColor.setStroke()
        mukPath.stroke()
        mukPath.fill()
        
        let mukEnd1 = CGFloat.pi * 1.5
        let mukPath1 = UIBezierPath(arcCenter: mukCenter, radius: mukRadius, startAngle: mukStart, endAngle: mukEnd1, clockwise: true)
        
        // Path for Ligher Ring
        mukPath1.lineWidth = mukLineWidth
        UIColor.clear.setFill()
        mukRingColor.withAlphaComponent(CGFloat(0.2)).setStroke()
        mukPath1.stroke()
        mukPath1.fill()
    }

}
