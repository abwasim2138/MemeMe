//
//  Memes.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import Foundation
import UIKit

private let arrayKey = "memesArray"
class Memes {
    
    static let memeLibrary = Memes()  //singleton
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var memes = [Meme]()
  
    func addMeme (meme: Meme) {
        memes.append(meme)
    }
    
    func replaceMeme (meme: Meme, indexPathRow: Int) {
        memes[indexPathRow] = meme
    }
    
    func removeMeme (meme: Meme) {
        if let index = memes.indexOf(meme) {
            memes.removeAtIndex(index)
        }
    }
    
}