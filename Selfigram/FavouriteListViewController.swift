//
//  FavouriteListViewController.swift
//  Selfigram
//
//  Created by adrian on 2016-04-03.
//  Copyright © 2016 adrian. All rights reserved.
//

import UIKit
import Parse

class FavouriteListViewController: UITableViewController {
    
    @IBOutlet var favTable: UITableView!
    var favList = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Favourites")
        query.whereKey("username", equalTo: "Adrian")
        query.orderByDescending("createdAt")
        
        
        query.findObjectsInBackgroundWithBlock ({ (results, error) -> Void in
           
            if let result = results {
                for favItem in result {
                        if let imageFile = favItem["imageFile"] as? PFFile {
                            self.favList.append(imageFile)
                            for item in self.favList {
                                print(item)
                            }
                            self.favTable.reloadData()
                    }
                }
            }
        })
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // #warning Incomplete implementation, return the number of rows
        return favList.count
 
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("favImageCell", forIndexPath: indexPath) as! FavImageCell
        
        cell.favImageView.image = nil
        
        let image = favList[indexPath.row]
        image.getDataInBackgroundWithBlock({(data, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                cell.favImageView.image = image
            }
            
        })
        
        
        return cell
        
        
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
