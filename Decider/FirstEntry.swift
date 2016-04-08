//
//  NewEntryController.swift
//  Decider
//
//  Created by Jalen Massey on 07/04/2016.
//  Copyright © 2016 Jalen Massey. All rights reserved.
//

import UIKit

class FirstEntry: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segue.identifier == "addRow" {
            if let destinationVC = segue.destinationViewController as? TableController {
                if(textField.text! != "") {
                    destinationVC.entries.append(textField.text!)
                }
            }
        }
    }
    
}
