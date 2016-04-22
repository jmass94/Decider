//
//  ViewController.swift
//  Decider
//
//  Created by Jalen Massey on 17/03/2016.
//  Copyright © 2016 Jalen Massey. All rights reserved.
//

/*
 * Spin by deciding an option beforehand, and spinning to a random spot in that interval
 */

import UIKit

private extension CGPoint {
    // Get the length (a.k.a. magnitude) of the vector
    var length: CGFloat { return sqrt(self.x * self.x + self.y * self.y) }
    
    // Normalize the vector (preserve its direction, but change its magnitude to 1)
    var normalized: CGPoint { return CGPoint(x: self.x / self.length, y: self.y / self.length) }
}

class ViewController: UIViewController {
    ////////////
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    ////////////

    /*
     * Timers
     */
    var timer: NSTimer!
    var answer: NSTimer!
    var timeAmt: NSTimeInterval!
    
    //Rads/sec to spin spinner
    var num = 1.5
    var spinnerPosition = (3*M_PI)/2.0
    
    var deltaAngle : Float!
    var startTransform : CGAffineTransform!
    
    
    var entries = [String]()
    
    @IBOutlet weak var redSquare: UIView!
    @IBOutlet weak var blueSquare: UIView!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var spinView: Spinner!
    @IBOutlet weak var spinButton: UIBarButtonItem!
    
    private var originalBounds = CGRect.zero
    private var originalCenter = CGPoint.zero
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    

    /* Gestures */
    /* TO DO */
    var v1 = CGPointZero
    var totalAngle = 0.0
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBAction func manualRotate(sender: UIPanGestureRecognizer) {
        print(sender.velocityInView(self.view))
        let pt = sender.locationInView(self.view)
        let dx = pt.x - self.view.center.x
        let dy = pt.y - self.view.center.y
        let ang = atan2(Float(dy), Float(dx))
        let angleDifference = deltaAngle - ang;
        //print(angleDifference)
        totalAngle = Double(angleDifference)
        //print(totalAngle)
        spinView.transform = CGAffineTransformRotate(startTransform, CGFloat(-angleDifference))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addGestureRecognizer(panGesture)
        setWheel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = spinView.bounds
        originalCenter = spinView.center
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPoint = touches.first?.locationInView(self.view) {
            let dx = touchPoint.x - self.view.center.x
            let dy = touchPoint.y - self.view.center.y
            
            print(spinnerPosition)
            deltaAngle = atan2(Float(dy), Float(dx));
            startTransform = self.view.transform
        }
        super.touchesBegan(touches, withEvent: event)
    }
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let pt = touches.first?.locationInView(self.view) {
//            let dx = pt.x - self.view.center.x
//            let dy = pt.y - self.view.center.y
//            let ang = atan2(Float(dy), Float(dx))
//            let angleDifference = deltaAngle - ang;
//            print(angleDifference)
//            totalAngle = Double(angleDifference)
//            print(totalAngle)
//            spinView.transform = CGAffineTransformRotate(startTransform, CGFloat(-angleDifference))
//        }
//        super.touchesMoved(touches, withEvent: event)
//        
//    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        spinnerPosition += totalAngle
        if(spinnerPosition > (2*M_PI)) {
            spinnerPosition -= (2*M_PI)
        } else if spinnerPosition < 0 {
            spinnerPosition += (2*M_PI)
        }
        print(spinnerPosition)
        super.touchesEnded(touches, withEvent: event)
    }
    /* -------- */
    
    var wedgeCount : Int = 2
    var wedgeRanges = [0.0]
    
    @IBAction func boop(sender: UIBarButtonItem) {
        startSpinning()
        spinButton.enabled = false
    }
    
    func setWheel() {
        spinView.wedges = wedgeCount
        let spacer = (2*M_PI) / Double(wedgeCount)
        for(var i = 1; i <= wedgeCount; i++) {
            wedgeRanges.append(wedgeRanges[i-1]+spacer)
        }
    }
    
    func startSpinning() {
        decisionLabel.alpha = 0.0
        decisionLabel.text = "Spinning..."
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                self.decisionLabel.alpha = 1.0
            }) { (Bool) -> Void in
                
        }
        
        var tenth = Double(round((Float(arc4random()) /  Float(UInt32.max))*10)/10) + Double(arc4random_uniform(5)+3)
        //Round down to the first decimal place
        tenth = round(tenth*10)/10
        
        //Initialize timer
        timeAmt = NSTimeInterval.init(tenth)
        answer = NSTimer.scheduledTimerWithTimeInterval(timeAmt,
            target: self,
            selector: Selector("wrapUp"),
            userInfo: nil,
            repeats: false)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self,
            selector: Selector("rotate"),
            userInfo: nil,
            repeats: true)
    }
    
    func rotate() {
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: .CurveLinear,
            animations: { () -> Void in
                self.spinView.transform = CGAffineTransformRotate(self.spinView.transform, CGFloat(self.num))
            }) { (Bool) -> Void in
        }
        
        spinnerPosition -= num
        if spinnerPosition < 0 {
            spinnerPosition += (2*M_PI)
        }
    }
    
    func wrapUp() {
        timer.invalidate()
        
        let arc4randoMax:Double = 0x100000000
        let upper = 0.0
        let lower = M_PI
        let extraSpin = Double((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower)
        
        /*
         * Spinner should move to new direction clockwise
         */
        //let finishSpinBy = (2*M_PI)-extraSpin
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                self.spinView.transform = CGAffineTransformRotate(self.spinView.transform, CGFloat(1.5))
            }) { (Bool) -> Void in
    
        }
        UIView.animateWithDuration(1.0, delay: 0.3, options: .CurveEaseOut, animations: { () -> Void in
            self.spinView.transform = CGAffineTransformRotate(self.spinView.transform, CGFloat(extraSpin))
            }) { (Bool) -> Void in
                
        }
        
        spinnerPosition -= (1.5+extraSpin)
        if spinnerPosition < (0) {
            spinnerPosition += ((2*M_PI))
        }
        var count = 0
        while count < wedgeRanges.count {
            if (spinnerPosition >= wedgeRanges[count] && spinnerPosition <= wedgeRanges[count+1]) {
                UIView.animateWithDuration(0.5,
                    delay: 0,
                    options: .CurveEaseIn,
                    animations: { () -> Void in
                        self.decisionLabel.alpha = 0
                    }, completion: { (Bool) -> Void in
                })
                decisionLabel.text = "The spinner chose \(entries[count])!"
                UIView.animateWithDuration(0.5,
                    delay: 0.5,
                    options: .CurveEaseIn,
                    animations: { () -> Void in
                        self.decisionLabel.alpha = 1.0
                    }, completion: { (Bool) -> Void in
                        self.spinView.getBig(count)
                })
                break
            } else {
                count++
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

