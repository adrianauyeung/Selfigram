//
//  EnlargeImageViewController.swift
//  Selfigram
//
//  Created by adrian on 2016-03-31.
//  Copyright © 2016 adrian. All rights reserved.
//

import UIKit

class EnlargeImageViewController: UIViewController {
    
    var post: Post!
    
    @IBOutlet weak var enlargeImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
