//
//  Post.swift
//  Selfigram
//
//  Created by adrian on 2016-03-22.
//  Copyright © 2016 adrian. All rights reserved.
//

import Foundation
import UIKit

class Post {
    // WILL UPDATE TO V2: use Parse
    //let image:UIImage   // this lets us use an image we supply
    let imageURL:NSURL      // this lets us use an image supplied by the URL
    let user:User
    let comment:String
    
    //init(image:UIImage, user:User, comment:String){  // this lets us use an image we supply
    init(imageURL:NSURL, user:User, comment:String){
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        // So for example we are passing in an UImage called image and setting it as our
        // image property for Post.
        self.imageURL = imageURL
        self.user = user
        self.comment = comment
    }
}