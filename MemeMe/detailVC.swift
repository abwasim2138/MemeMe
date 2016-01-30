//
//  detailVC.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import UIKit

class detailVC: UIViewController {

    var indexPathRow: Int? = Int()
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathRow = indexPathRow {
            imageView.image = Memes.memeLibrary.memes[indexPathRow].memedImage
        }
        
    }

    //MARK: - NAVIGATION 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let iPathRow = indexPathRow {
        if segue.identifier == "showEditScreen" {
            let editVC = segue.destinationViewController as! MemeEditorVC
            editVC.editingExistingMeme = true
            editVC.indexPathRow = iPathRow
            print(iPathRow)
            }
        }
    }
    
    
    
    
    
    
    
    
    

}
