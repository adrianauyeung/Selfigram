//
//  EnlargeImageViewController.swift
//  Selfigram
//
//  Created by adrian on 2016-03-31.
//  Copyright © 2016 adrian. All rights reserved.
//

import UIKit
import Parse


class EnlargeImageViewController: UIViewController {
    
    var post: Post!
    
    @IBOutlet weak var favText: UILabel!
    @IBOutlet weak var enlargeImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favText.text = "Tap to favourite image"
        
        let task = NSURLSession.sharedSession().downloadTaskWithURL(post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url,
                let imageData = NSData(contentsOfURL: imageURL){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.enlargeImage?.image = UIImage(data: imageData)
                        
                    })
            }
        }
        
        task.resume()

    }
    
    @IBAction func favImage(sender: AnyObject) {
        // Connect to Part
        let favImage = PFObject(className: "Favourites")
        favImage["imageTitle"] = post.comment
        
        // Convert image into Parse compatible data
        if let imageData = UIImageJPEGRepresentation((self.enlargeImage?.image)!, 0.9),
            let imageFile = PFFile(data: imageData){
                favImage["imageFile"] = imageFile
        }
        
        
        // Login as Adrian
        let user = PFUser()
        let username = "Adrian"
        let password = "abcd1234"
        user.username = username
        user.password = password
        
        // Sign into parse
        PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            if let user = user {
                favImage["username"] = user.username
                
                // Save favourite image data to Parse
                favImage.saveInBackgroundWithBlock({ (success, error) in
                    if success {
                        print("Favourite Image successfully saved")
                        
                        
                    } else {
                        print("save failed")
                    }
                })
            }
        })
        

        

        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
