//
//  dbView.swift
//  volume
//
//  Created by Jalen Massey on 17/02/2016.
//  Copyright © 2016 cs473. All rights reserved.
//

import UIKit

class spinner: UIView {
    
    var bnds : CGRect!
    var maxX : CGFloat = 0.0
    var maxY : CGFloat = 0.0
    
    //Layers
    var spinnerHolder = CALayer()
    var wedgeLayer: [CAShapeLayer]!
    var stopperLayer: CAShapeLayer!
    //////
    
    var rads : CGFloat = 0.0
    
    var spinIt = 0.0 {
        didSet {
            spinnerHolder.transform = CATransform3DRotate(spinnerHolder.transform, rads, 0.0, 0.0, 1.0)
        }
    }
    
    var wedges : Int = 0
    
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
        
        //Remove all sublayers
        layer.sublayers?.removeAll()
        spinnerHolder.sublayers?.removeAll()
        wedgeLayer?.removeAll()
        wedgeLayer = [CAShapeLayer]()
        /////////
        let context = UIGraphicsGetCurrentContext()
        bnds = self.bounds
        maxX = bnds.size.width
        maxY = bnds.size.height
        
        self.backgroundColor?.setFill()
        CGContextFillRect(context, bounds)
        
        var startAngle = 0.0
        var endAngle = (1.0/Double(wedges))*(2*M_PI)
        let arcLength = endAngle
        let center = CGPointMake(0.0, 0.0)
        
        /* Sets spinner radius relative to device orientation */
        let oriX : CGFloat
        
        /* Landscape mode */
        if maxX > maxY {
            oriX = maxY
        }
        /* Portrait */
        else {
            oriX = maxX
        }
        
        let cPathRadius = CGFloat((oriX/2) - 50.0)
        let wedgeCenter = CGPoint(x: maxX/2.0, y: maxY/2.0 - cPathRadius+25)
        var i = 1
        //beyondEight will only be necessary if I want the user to be able to do more than 8 options
        var beyondEight = i
        var tempWedges = wedges
        while i  <= tempWedges {
            /*
             * Create each individual wedge and add it to the spinnerHolder
             */
            let wedgePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: cPathRadius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
            let tempWedgePath = CAShapeLayer()
            wedgePath.addLineToPoint(center)
            tempWedgePath.path = wedgePath.CGPath
            //Fill color using Colors class
            switch(i) {
            case 1:
                tempWedgePath.fillColor = Colors.W_ONE
                break
            case 2:
                tempWedgePath.fillColor = Colors.W_TWO
                break
            case 3:
                tempWedgePath.fillColor = Colors.W_THREE
                break
            case 4:
                tempWedgePath.fillColor = Colors.W_FOUR
                break
            case 5:
                tempWedgePath.fillColor = Colors.W_FIVE
                break
            case 6:
                tempWedgePath.fillColor = Colors.W_SIX
                break
            case 7:
                tempWedgePath.fillColor = Colors.W_SEV
                break
            case 8:
                tempWedgePath.fillColor = Colors.W_EIGHT
                break
            default:
                tempWedgePath.fillColor = UIColor.blackColor().CGColor
                break
            }
        
            wedgeLayer.append(tempWedgePath)
        
            startAngle = endAngle
            endAngle = endAngle+arcLength
            spinnerHolder.addSublayer(wedgeLayer[Int(beyondEight-1)])
            i++
            beyondEight++
            if i == 9 {
                tempWedges -= 8
                i -= 8
            }
        }
        
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
        
        /* Spinner center */
        let spinnerHole = UIBezierPath(arcCenter: CGPoint(x: maxX/2.0, y: maxY/2.0), radius: CGFloat((oriX/2)/12), startAngle: 0, endAngle: 6.28, clockwise: true)
        let holeLayer = CAShapeLayer()
        holeLayer.path = spinnerHole.CGPath
        holeLayer.fillColor = UIColor.blackColor().CGColor
        
        //Translate spinnerHolder to middle of screen
        spinnerHolder.transform = CATransform3DMakeTranslation(maxX/2.0, maxY/2.0, 0.0)
        
        //Add all previous layers to view's layer
        layer.addSublayer(spinnerHolder)
        layer.addSublayer(holeLayer)
        layer.addSublayer(pointerLayer)
        layer.addSublayer(tickerLayer)
    }
    
    func getBig(count : Int) {
        if let tempLayer = layer.sublayers!.first!.sublayers {
            for lyr in tempLayer {
                if tempLayer.indexOf(lyr) == count {
                    lyr.transform = CATransform3DScale(lyr.transform, 1.03, 1.03, 1.0)
                } else {
                    lyr.transform = CATransform3DScale(lyr.transform, 0.85, 0.85, 1.0)
                }
            }
        }
    }
    
    func reset() {
        self.setNeedsDisplay()
    }
    
}
