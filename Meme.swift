//
//  Meme.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/27/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import Foundation
import UIKit

struct Meme: Equatable {
    let view: UIView
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    var memedImage: UIImage
    
}

func ==(lhs: Meme, rhs: Meme) -> Bool {
    return lhs.memedImage == rhs.memedImage
}

