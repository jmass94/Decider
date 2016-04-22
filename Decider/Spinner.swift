//
//  dbView.swift
//  volume
//
//  Created by Jalen Massey on 17/02/2016.
//  Copyright © 2016 cs473. All rights reserved.
//

import UIKit

class Spinner: UIView {
    
    var bnds : CGRect!
    var maxX : CGFloat = 0.0
    var maxY : CGFloat = 0.0
    
    //Layers
    var spinnerHolder = CALayer()
    var wedgeLayer: [CAShapeLayer]!
    //////
    
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
        
        let cPathRadius = CGFloat((maxX/2) - 50.0)
        var i = 1
        var temp_i = i
        var tempWedges = wedges
        
        wedgeLayer = [CAShapeLayer]()
        
        while i  <= tempWedges {
            /*
             * Create each individual wedge and add it to the spinnerHolder
             */
            let wedgePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0),
                radius: cPathRadius,
                startAngle: CGFloat(startAngle),
                endAngle: CGFloat(endAngle),
                clockwise: true)
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
            
            tempWedgePath.strokeColor = UIColor.blackColor().CGColor
        
            wedgeLayer.append(tempWedgePath)
        
            startAngle = endAngle
            endAngle = endAngle+arcLength
            spinnerHolder.addSublayer(wedgeLayer[Int(temp_i-1)])
            i++
            temp_i++
            if i == 9 {
                tempWedges -= 8
                i -= 8
            }
        }
        
        /* Spinner center */
        let spinnerHole = UIBezierPath(arcCenter: CGPoint(x: maxX/2.0, y: maxY/2.0), radius: CGFloat((maxX/2)/12), startAngle: 0, endAngle: 6.28, clockwise: true)
        let holeLayer = CAShapeLayer()
        holeLayer.path = spinnerHole.CGPath
        holeLayer.fillColor = UIColor.blackColor().CGColor
        
        //Translate spinnerHolder to middle of screen
        spinnerHolder.transform = CATransform3DMakeTranslation(maxX/2.0, maxY/2.0, 0.0)
        
        //Add all previous layers to view's layer
        layer.addSublayer(spinnerHolder)
        layer.addSublayer(holeLayer)
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
    
}
