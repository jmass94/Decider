//
//  ViewController.swift
//  Decider
//
//  Created by Jalen Massey on 17/03/2016.
//  Copyright © 2016 Jalen Massey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: NSTimer!
    var answer: NSTimer!
    var timeAmt: NSTimeInterval!
    
    var num = 1.48352986419518
    
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
        
        spinView.spinIt = spinView.spinIt + 0.000001
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
    
    @IBAction func boop(sender: UIBarButtonItem) {
        if stateSuspended {
            spinView.goBack()
            timer = NSTimer.scheduledTimerWithTimeInterval(1,
                target: self,
                selector: "startSpinning",
                userInfo: nil,
                repeats: false)
        } else if !currentlySpinning {
            startSpinning()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addGestureRecognizer(rotateGesture)
        setWheel()
    }
    
    func setWheel() {
        print(wedgeCount)
        spinView.wedges = wedgeCount
    }
    
    func stopWheel() {
        currentlySpinning = false
        stateSuspended = true
        timer.invalidate()
        if spinnerPosition < 0 {
            spinnerPosition += (2*M_PI)
        }
        spinnerPosition += 0.0000001 //In case of the spinner landing in the middle
        
        let spacer = (2*M_PI) / Double(wedgeCount)
        var wedgeRanges = [0.0]
        for(var i = 1; i <= wedgeCount; i++) {
            wedgeRanges.append(wedgeRanges[i-1]+spacer)
        }
        
        print(entries)
        print(wedgeRanges)
        
        var count = 0
        print(spinnerPosition)
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
        spinnerPosition = (3*M_PI)/2.0
        decisionLabel.text = "Spinning..."
        currentlySpinning = true
        stateSuspended = false
        setAngle()
        
        var tenth = Double(round((Float(arc4random()) /  Float(UInt32.max))*10)/10) + Double(arc4random_uniform(5)+3)
        //Round down to the first decimal place
        tenth = round(tenth*10)/10
        
        //Initialize timer
        timeAmt = NSTimeInterval.init(tenth)
        print(timeAmt)
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
    
    func updateMeter() {      
        spinView.spinnerHolder.transform = CATransform3DRotate(spinView.spinnerHolder.transform, CGFloat(num), 0.0, 0.0, 1.0)
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

