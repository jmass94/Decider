//
//  NewEntryController.swift
//  Decider
//
//  Created by Jalen Massey on 07/04/2016.
//  Copyright © 2016 Jalen Massey. All rights reserved.
//

import UIKit

class NewEntryController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var entries = [String]()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segue.identifier == "addRow" {
            if let destinationVC = segue.destinationViewController as? TableController {
                if(textField.text! != "") {
                    entries.append(textField.text!)
                    destinationVC.entries = entries
                }
                else {
                    destinationVC.entries = entries
                }
            }
        }
    }
}
