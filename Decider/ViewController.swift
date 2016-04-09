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

    var timer: NSTimer!
    var answer: NSTimer!
    var timeAmt: NSTimeInterval!
    
    var num = 1.5
    
    var spinnerPosition : Double = 0.0
    
    var currentlySpinning : Bool = false
    var stateSuspended : Bool = false
    
    var entries = [String]()
    
    @IBOutlet weak var decisionLabel: UILabel!
    
    @IBOutlet weak var spinView: spinner!

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
    
    @IBAction func boop(sender: UIBarButtonItem) {
        if stateSuspended {
            spinView.reset()
            currentlySpinning = true
            stateSuspended = false
            timer = NSTimer.scheduledTimerWithTimeInterval(1,
                target: self,
                selector: "startSpinning",
                userInfo: nil,
                repeats: false)
        } else if !currentlySpinning {
            currentlySpinning = true
            stateSuspended = false
            startSpinning()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.addGestureRecognizer(rotateGesture)
        setWheel()
    }
    
    func setWheel() {
        spinView.wedges = wedgeCount
        let spacer = (2*M_PI) / Double(wedgeCount)
        for(var i = 1; i <= wedgeCount; i++) {
            wedgeRanges.append(wedgeRanges[i-1]+spacer)
        }
    }
    
    func stopWheel() {
        currentlySpinning = false
        stateSuspended = true
        timer.invalidate()
        /*
         * spinnerPosition should keep up with actual spinner
         * Decrements spinnerPosition once more to replicate actual spinner position
         */
//        spinnerPosition -= num
//        if spinnerPosition < 0 {
//            spinnerPosition += (2*M_PI)
//        }
        
        let arc4randoMax:Double = 0x100000000
        let upper = wedgeRanges[decision+1]
        let lower = wedgeRanges[decision]
        let interval = Double((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower)
        var difference = interval-spinnerPosition
        if difference < 0 {
            difference += (2*M_PI)
        }
        
        var question = difference-interval
        if question < 0 {
            question += (2*M_PI)
        }
        
        /*
         * Spinner should move to new direction clockwise
         */
        spinView.spinnerHolder.transform = CATransform3DRotate(spinView.spinnerHolder.transform, CGFloat((2*M_PI)-difference), 0.0, 0.0, 1.0)
        //spinView.spinnerHolder.transform = CATransform3DMakeTranslation(spinView.maxX/2, spinView.maxY/2, 1.0)

        spinnerPosition += difference
        if spinnerPosition > (2*M_PI) {
            spinnerPosition -= ((2*M_PI))
        }
        var count = 0
        while count < wedgeRanges.count {
            if (spinnerPosition >= wedgeRanges[count] && spinnerPosition <= wedgeRanges[count+1]) {
                decisionLabel.text = "The spinner chose \(entries[count])!"
                spinView.getBig(count)
                break
            } else {
                count++
            }
        }
        
    }
    
    func startSpinning() {
        let eCount = entries.count
        let toThis = UInt32(eCount)
        decision = Int(arc4random() % toThis)
        print("Decision: \(entries[decision])")
        
        spinnerPosition = (3*M_PI)/2.0
        decisionLabel.text = "Spinning..."
        setAngle()
        
        var tenth = Double(round((Float(arc4random()) /  Float(UInt32.max))*10)/10) + Double(arc4random_uniform(5)+3)
        //Round down to the first decimal place
        tenth = round(tenth*10)/10
        
        //Initialize timer
        timeAmt = NSTimeInterval.init(tenth)
        answer = NSTimer.scheduledTimerWithTimeInterval(timeAmt,
            target: self,
            selector: Selector("stopWheel"),
            userInfo: nil,
            repeats: false)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self,
            selector: Selector("updateMeter"),
            userInfo: nil,
            repeats: true)
    }
    
    func setAngle() {
        //spinView.angle = Int(arc4random_uniform(180) + 1)
        //spinView.rads = CGFloat(Double(spinView.angle) / 180 * Double(M_PI))
        
    }
    
    func rotate() {
        spinView.spinnerHolder.transform = CATransform3DRotate(spinView.spinnerHolder.transform, CGFloat(num), 0.0, 0.0, 1.0)
    }
    
    func updateMeter() {      
        rotate()
        spinnerPosition -= num
        if spinnerPosition < 0 {
            spinnerPosition += (2*M_PI)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

