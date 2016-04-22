//
//  Ticker.swift
//  Decider
//
//  Created by Jalen Massey on 21/04/2016.
//  Copyright © 2016 Jalen Massey. All rights reserved.
//

import UIKit

class Ticker: UIView {
    
    var bnds : CGRect!
    var maxX : CGFloat = 0.0
    var maxY : CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .Redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentMode = .Redraw
    }
    
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        bnds = self.bounds
        maxX = bnds.size.width
        maxY = bnds.size.height
        
        self.backgroundColor?.setFill()
        CGContextFillRect(context, bounds)
        
        /* Sets spinner radius relative to device orientation */
        let cPathRadius = CGFloat((maxX/2) - 50.0)
        let wedgeCenter = CGPoint(x: maxX/2.0, y: maxY/2.0 - cPathRadius+25)
        
        /* Create ticker wedge */
        let tickerPath = UIBezierPath(arcCenter: wedgeCenter, radius: CGFloat(50.0), startAngle: 4.2, endAngle: 5.22, clockwise: true)
        tickerPath.addLineToPoint(wedgeCenter)
        let tickerLayer = CAShapeLayer()
        tickerLayer.path = tickerPath.CGPath
        tickerLayer.fillColor = UIColor.blackColor().CGColor
        
        /* Create ticker pointer */
        let pointer = UIBezierPath(arcCenter: CGPoint(x: maxX/2.0, y: maxY/2.0 - cPathRadius+25), radius: 3, startAngle: 0, endAngle: 6.28, clockwise: true)
        let pointerLayer = CAShapeLayer()
        pointerLayer.path = pointer.CGPath
        pointerLayer.fillColor = UIColor.whiteColor().CGColor
        
        layer.addSublayer(tickerLayer)
        layer.addSublayer(pointerLayer)
    }
}
