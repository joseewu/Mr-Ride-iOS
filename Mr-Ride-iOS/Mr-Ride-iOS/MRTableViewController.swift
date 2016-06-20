//
//  MRTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//

import UIKit
import SWRevealViewController

class MRTableViewController: UITableViewController {
    let dataArray = ["","Home","History"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.mrDarkSlateBlueColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MenuTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuTableViewCell
        cell.backgroundColor  = UIColor.mrDarkSlateBlueColor()
        cell.menuButton.setTitle(dataArray[indexPath.row], forState: .Normal)
        cell.menuButton.tintColor = UIColor.whiteColor()
        cell.menuButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 24)
        if indexPath.row == 0 {
            cell.decaration.backgroundColor = UIColor.clearColor()
        }else{
            cell.decaration.backgroundColor = UIColor.mrDarkSlateBlueColor()
            cell.decaration.layer.cornerRadius = cell.decaration.frame.size.height/2
            cell.decaration.clipsToBounds = true
        }
        cell.selectionStyle = .None
        
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row{
            
        case 1:
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeNavi") as! UINavigationController
            let  segueToHome = SWRevealViewControllerSeguePushController.init(identifier: SWSegueRearIdentifier, source: self, destination: vc)
            segueToHome.perform()
            print(indexPath.row)
        case 2:
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryNavi") as! UINavigationController
            let  segueToHistory = SWRevealViewControllerSeguePushController.init(identifier: SWSegueRearIdentifier, source: self, destination: vc)
            segueToHistory.perform()
            print(indexPath.row)
        default: return
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
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
