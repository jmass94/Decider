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
    private var timer: NSTimer!
    
    //Rads/sec to spin spinner
    private var num = 1.5
    private var spinnerPosition = (3*M_PI)/2.0
    
    private var deltaAngle : Float!
    private var startTransform : CGAffineTransform!
    private var radius: Double!
    
    var entries = [String]()
    
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var spinView: Spinner!
    @IBOutlet weak var spinButton: UIBarButtonItem!
    
    /*
     * Wedge Information
     */
    var wedgeCount : Int = 2
    private var wedgeRanges = [0.0]

    /* Gestures */
    private var totalAngle = 0.0
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBAction func manualRotate(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocityInView(self.view)
        let magvel = Double(sqrt(pow(velocity.x, 2)+pow(velocity.y, 2)))
        if(sender.state == UIGestureRecognizerState.Ended) {
            self.num = (magvel/self.radius)/10
            flickToSpin()
        }
        let pt = sender.locationInView(self.view)
        let dx = pt.x - self.view.center.x
        let dy = pt.y - self.view.center.y
        let ang = atan2(Float(dy), Float(dx))
        let angleDifference = deltaAngle - ang;
        totalAngle = Double(angleDifference)
        spinView.transform = CGAffineTransformRotate(startTransform, CGFloat(-angleDifference))
        
    }
    
    /*
     * Spin wheel with finger
     */
    private func flickToSpin() {
        self.spinnerPosition += totalAngle
        if(self.spinnerPosition > (2*M_PI)) {
            self.spinnerPosition -= (2*M_PI)
        } else if self.spinnerPosition < 0 {
            self.spinnerPosition += (2*M_PI)
        }
        startSpinning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addGestureRecognizer(panGesture)
        setWheel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPoint = touches.first?.locationInView(self.view) {
            let dx = touchPoint.x - self.view.center.x
            let dy = touchPoint.y - self.view.center.y
            radius = Double(sqrt(pow(dx, 2) + pow(dy, 2)))
            deltaAngle = atan2(Float(dy), Float(dx));
            startTransform = self.view.transform
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    /* -------- */
    
    //Spin wheel with button
    @IBAction func boop(sender: UIBarButtonItem) {
        startSpinning()
    }
    
    private func setWheel() {
        spinView.wedges = wedgeCount
        let spacer = (2*M_PI) / Double(wedgeCount)
        for(var i = 1; i <= wedgeCount; i++) {
            wedgeRanges.append(wedgeRanges[i-1]+spacer)
        }
    }
    
    private func startSpinning() {
        spinButton.enabled = false
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
        let timeAmt = NSTimeInterval.init(tenth)
        NSTimer.scheduledTimerWithTimeInterval(timeAmt,
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
        
        self.spinnerPosition -= num
        if self.spinnerPosition < 0 {
            self.spinnerPosition += (2*M_PI)
        }
    }
    
    func wrapUp() {
        timer.invalidate()
        
        let arc4randoMax:Double = 0x100000000
        let upper = 0.0
        let lower = self.num
        let extraSpin = Double((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower)
        /*
         * Spinner should move to new direction clockwise
         */
        //let finishSpinBy = (2*M_PI)-extraSpin
        UIView.animateWithDuration(1, delay: 0, options: .CurveLinear, animations: { () -> Void in
                self.spinView.transform = CGAffineTransformRotate(self.spinView.transform, CGFloat(self.num))
            }) { (Bool) -> Void in
    
        }
        UIView.animateWithDuration(1.0, delay: 1, options: .CurveEaseOut, animations: { () -> Void in
            self.spinView.transform = CGAffineTransformRotate(self.spinView.transform, CGFloat(extraSpin))
            }) { (Bool) -> Void in
                
        }
        
        self.spinnerPosition -= (num+extraSpin)
        if self.spinnerPosition < (0) {
            self.spinnerPosition += ((2*M_PI))
        }
        var count = 0
        while count < wedgeRanges.count {
            if (self.spinnerPosition >= wedgeRanges[count] && self.spinnerPosition <= wedgeRanges[count+1]) {
                UIView.animateWithDuration(0.5,
                    delay: 0,
                    options: .CurveEaseIn,
                    animations: { () -> Void in
                        self.decisionLabel.alpha = 0
                    }, completion: { (Bool) -> Void in
                })
                decisionLabel.text = "The spinner chose \(entries[count])!"
                UIView.animateWithDuration(0.5,
                    delay: 1.5,
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
        self.view.removeGestureRecognizer(panGesture)
        //self.view.removeGestureRecognizer(rotateGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

