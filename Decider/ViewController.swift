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
    
    var spinningFlag : Bool = false
    
    @IBOutlet weak var spinView: spinner!

    /* Gestures */
    @IBAction func panSpeed(sender: UIPanGestureRecognizer) {
        let speed = sender.velocityInView(spinView)
        let radsToSpin : Double
        
        //spinView.spinIt = spinView.spinIt + 0.000001
        print(speed)
    }
    
    /* -------- */
    
    @IBOutlet weak var mySlider: UISlider!
    
    var wedgeCount : Int = 2
    
    @IBAction func sliderChanges(sender: UISlider) {
        sender.setValue(Float(lroundf(mySlider.value)), animated: true)
        wedgeCount = Int(sender.value)
        spinView.wedges = Double(sender.value)
    }
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func boop(sender: UIButton) {
        if(spinningFlag) {
            timer.invalidate()
            sender.setTitle("Spin!", forState: UIControlState.Normal)
            spinningFlag = false
            spinView.spinIt = 0
        }
        else {
            startSpinning()
            //sender.setTitle("Stop!", forState: UIControlState.Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        spinView.wedges = Double(wedgeCount)
    }
    
    func stopWheel() {
        timer.invalidate()
        spinningFlag = false
        spinView.spinIt = 0
        num = 1.48352986419518
    }
    
    func startSpinning() {
        setAngle()
        
        timeAmt = NSTimeInterval.init(Double(arc4random_uniform(3)+3))
        
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
        spinningFlag = true
    }
    
    func setAngle() {
        spinView.angle = Int(arc4random_uniform(180) + 1)
        //spinView.rads = CGFloat(Double(spinView.angle) / 180 * Double(M_PI))
        
    }
    
    func updateMeter() {
        spinView.rads = CGFloat(num - (num*0.04))
        num = Double(spinView.rads)
        spinView.spinIt = spinView.spinIt + 0.000001
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rowCount" {
            if let destinationVC = segue.destinationViewController as? TableController {
                 destinationVC.numEntries = Int(mySlider.value)
            }
        }
    }
}

