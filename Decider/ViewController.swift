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
    var timer: NSTimer!
    var answer: NSTimer!
    var timeAmt: NSTimeInterval!
    
    //Rads/sec to spin spinner
    var num = 1.5
    
    var spinnerPosition = (3*M_PI)/2.0
    
    var entries = [String]()
    
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var spinView: Spinner!
    @IBOutlet weak var spinButton: UIBarButtonItem!

    /* Gestures */
    /* TO DO */
    @IBOutlet var rotateGesture: UIRotationGestureRecognizer!
    @IBAction func panSpeed(sender: UIPanGestureRecognizer) {
        //let speed = sender.velocityInView(spinView)
        
        //print(speed)
    }
//    @IBAction func rotation(sender: UIRotationGestureRecognizer) {
//        print("Rotation is \(sender.velocity)")
//        //spinView.rads = sender.velocity/CGFloat(2*M_PI)
//        spinView.spinnerHolder.transform = CATransform3DRotate(spinView.spinnerHolder.transform, sender.velocity/36, 0.0, 0.0, 1.0)
//        //spinView.spinIt = spinView.spinIt + 0.000001
//        spinnerPosition -= Double(sender.velocity)
//        if spinnerPosition < 0 {
//            spinnerPosition += (2*M_PI)
//        } else if spinnerPosition > (2*M_PI) {
//            spinnerPosition -= (2*M_PI)
//        }
//    }
    
    /* -------- */
    
    var wedgeCount : Int = 2
    var wedgeRanges = [0.0]
    var decision = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.addGestureRecognizer(rotateGesture)
        setWheel()
    }
    
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
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.spinView.transform = CGAffineTransformRotate(self.spinView.transform, CGFloat(1.5))
            }) { (Bool) -> Void in
    
        }
        UIView.animateWithDuration(1.0, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
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

