//
//  dbView.swift
//  volume
//
//  Created by Jalen Massey on 17/02/2016.
//  Copyright © 2016 cs473. All rights reserved.
//

import UIKit

class spinner: UIView {
    var layerHolder = CALayer()
    var circleLayer: [CAShapeLayer]!
    var stopperLayer: CAShapeLayer!

    var angle = 0
    var rads : CGFloat = 0.0
    
    var spinIt = 0.0 {
        didSet {
            layerHolder.transform = CATransform3DRotate(layerHolder.transform, rads, 0.0, 0.0, 1.0)
        }
    }
    
    var wedges = 2.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .Redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentMode = .Redraw
    }
    
    override func drawRect(rect: CGRect) {
        spinIt = 0.0
        layer.sublayers?.removeAll()
        layerHolder.sublayers?.removeAll()
        let context = UIGraphicsGetCurrentContext()
        let bounds = self.bounds
        
        self.backgroundColor?.setFill()
        CGContextFillRect(context, bounds)
        
        var i = 1.0
        var startAngle = (1/wedges)*(2*M_PI)
        var endAngle   = startAngle+startAngle
        let arcLength = endAngle - startAngle
        let center = CGPointMake(0.0, 0.0)
        
        circleLayer?.removeAll()
        circleLayer = [CAShapeLayer]()
        
        while i  <= wedges {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat((frame.size.width/2) - 50.0), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
            let tempCircleLayer = CAShapeLayer()
            circlePath.addLineToPoint(center)
            tempCircleLayer.path = circlePath.CGPath
            switch(i) {
            case 1:
                tempCircleLayer.fillColor = Colors.W_ONE
            case 2:
                tempCircleLayer.fillColor = Colors.W_TWO
            case 3:
                tempCircleLayer.fillColor = Colors.W_THREE
            case 4:
                tempCircleLayer.fillColor = Colors.W_FOUR
            case 5:
                tempCircleLayer.fillColor = Colors.W_FIVE
            case 6:
                tempCircleLayer.fillColor = Colors.W_SIX
            case 7:
                tempCircleLayer.fillColor = Colors.W_SEV
            case 8:
                tempCircleLayer.fillColor = Colors.W_EIGHT
            default:
                print("")
            }
        
            circleLayer.append(tempCircleLayer)
        
            startAngle = endAngle
            endAngle = endAngle+arcLength
            layerHolder.addSublayer(circleLayer[Int(i-1)])
            i++
        }
        
        layerHolder.borderWidth = 5.0
        layerHolder.borderColor = UIColor.greenColor().CGColor
        
        layerHolder.transform = CATransform3DMakeTranslation(bounds.size.width/2.0, bounds.size.height/2.0, 0.0)
    
        layer.addSublayer(layerHolder)
        
    }
    
}



//let stopperCetner = CGPointMake(CGFloat(bounds.width/2.0), CGFloat(bounds.size.height/2.0))

//        let stopper = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 3.0), radius: CGFloat((frame.size.width/5)), startAngle: CGFloat(((2.8/2)*M_PI)), endAngle: CGFloat(((3.2/2)*M_PI)), clockwise: true)
//        stopperLayer = CAShapeLayer()
//        stopperLayer.path = stopper.CGPath
//        stopper.addLineToPoint(stopperCetner)
//        stopperLayer.fillColor = UIColor.blackColor().CGColor
//        stopperLayer.strokeColor = UIColor.blackColor().CGColor
//        stopperLayer.lineWidth = 2.0
//
//        layer.addSublayer(stopperLayer)

//layerHolder.bounds = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)
