//
//  FeedViewController.swift
//  Selfigram
//
//  Created by adrian on 2016-03-22.
//  Copyright © 2016 adrian. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var searchTag: UITextField!
    
    var posts = [Post]()
    var tag = "city"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    func refreshTable() {
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=c49511cde0a768d5c81dff9fda15d2a5&tags=\(tag)")!) { (data, response, error) -> Void in
            
            if let jsonUnformatted = try? NSJSONSerialization.JSONObjectWithData(data!, options: []),
                let json = jsonUnformatted as? [String : AnyObject],
                let photosDictionary = json["photos"] as? [String : AnyObject],
                let photosArray = photosDictionary["photo"] as? [[String : AnyObject]]
            {
                //print(photosArray)
                for photo in photosArray {
                    if let farmID = photo["farm"] as? Int,
                        let serverID = photo["server"] as? String,
                        let photoID = photo["id"] as? String,
                        let secret = photo["secret"] as? String,
                        let title = photo["title"] as? String{
                            
                            //print("https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg")
                            
                            let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                            if let photoURL = NSURL(string: photoURLString){
                                let me = User(aUsername: title, aProfileImage: UIImage(named: "Grumpy-Cat")!)
                                let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
                                self.posts.append(post)
                            }
                    }
                    
                }
                
                // We use dispatch_async because we need update all UI elements on the main thread.
                // This is a rule and you will see this again whenever you are updating UI.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
                
            }else{
                print("error with response data")
            }
            
    }
    
        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")
        
        
        // UIImage has an initalized where you can pass in the name of an image in your project to create an UIImage
        // UIImage(named: "grumpy-cat") can return nil if there is no image called "grumpy-cat" in your project
        // Our definition of Post did not include the possibility of a nil UIImage
        // so, therefore we have to add a ! at the end of it
        
        let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//        let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 0")
//        let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 1")
//        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 2")
//        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 3")
//        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 4")
//        
//        posts = [post0, post1, post2, post3, post4]
        
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
        return self.posts.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SelfieCell
//        let post = posts[indexPath.row]
//        cell.imageView?.image = post.image
//        cell.textLabel?.text = post.comment
//        cell.textLabel?.text = words[indexPath.row]
        
//        let post = self.posts[indexPath.row]
//        cell.selfieImageView.image = post.image
//        cell.usernameLabel.text = post.user.username
//        cell.commentLabel.text = post.comment
//        
//        return cell
        
        //use flicker image starts here
        let post = self.posts[indexPath.row]
        // I've added this line to prevent flickering of images
        // We are inside the cellForRowAtIndexPath method that gets called everything we layout a cell
        // Because we are reusing "postCell" cells, a reused cell might have an image already set on it.
        // This always resets the image to blank, waits for the image to download, and then sets it
        cell.selfieImageView.image = nil
        
        let task = NSURLSession.sharedSession().downloadTaskWithURL(post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url,
                let imageData = NSData(contentsOfURL: imageURL){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.selfieImageView.image = UIImage(data: imageData)
                        
                    })
            }
        }
        
        task.resume()
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        return cell
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        print("Camera button pressed")
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .PhotoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .Camera
            pickerController.cameraDevice = .Front
            pickerController.cameraCaptureMode = .Photo
        }
        
        // Preset the pickerController on screen
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //2. We create a Post object from the image
            let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//            let post = Post(image: image, user: me, comment: "My Selfie")
            
            //3. Add post to our posts array
            //    Adds it to the very top of our array (and therefore our table, when we pi
//            posts.insert(post, atIndex: 0)
            
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()
        
    }

    
    @IBAction func updateTag(sender: AnyObject) {
        tag = searchTag.text!
        posts.removeAll()
        refreshTable()
        tableView.reloadData()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "enlargeImage" {
            let destination = segue.destinationViewController as! EnlargeImageViewController
            
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let currentPost = posts[indexPath.row]
            }
            // grab image or you can send the entire post.
            
//            destination.enlargeImage = ??
            
        }
    }
    

}
