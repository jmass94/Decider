//
//  TableController.swift
//  Decider
//
//  Created by Jalen Massey on 22/03/2016.
//  Copyright © 2016 Jalen Massey. All rights reserved.
//

import UIKit

class TableController: UITableViewController {
    
    var entries = [String]()
    
    @IBOutlet weak var addRowButton: UIBarButtonItem!
    @IBOutlet weak var goToSpinnerButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.toolbarHidden = false
        checkCount(2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkCount(8)
        return entries.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)

        if entries.count > 0 {
            cell.textLabel?.text = entries[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
//    //Conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        //Return false if you do not want the specified item to be editable.
//        return true
//    }
    
    func checkCount(count : Int) {
        switch(count) {
        case 2:
            if entries.count >= 2 {
                goToSpinnerButton.enabled = true
            } else {
                goToSpinnerButton.enabled = false
            }
            break
        case 8:
            if entries.count >= 8 {
                addRowButton.enabled = false
            } else {
                addRowButton.enabled = true
            }
            break
        default:
            print("")
            break
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            entries.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            checkCount(2)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segue.identifier == "rowCount" {
            if let destinationVC = segue.destinationViewController as? ViewController {
                destinationVC.wedgeCount = entries.count
                destinationVC.entries = entries
            }
        } else if segue.identifier == "toNewRow" {
            if let destinationVC = segue.destinationViewController as? NewEntryController {
                destinationVC.entries = entries
            }
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
