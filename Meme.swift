//
//  Meme.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/27/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let view: UIView
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    var memedImage: UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let mImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mImage
    }
    
    init(view: UIView, topText: String, bottomText: String, originalImage:UIImage) {
        self.view = view
        self.topText = topText
        self.originalImage = originalImage
        self.bottomText = bottomText
    }
    
}
