//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionVC: UICollectionViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private let memeCollection = Memes.memeLibrary
    private var indexPathRow = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CITE UIFundamentals II
        let size = (view.frame.size.width - (6.0)) / 3
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
        flowLayout.itemSize = CGSizeMake(size, size)

        
// CITE FOR ADDING LONGPRESSGR TO COLLECITONVIEW IN ORDER TO DELETE ITEM IN COLLECITON VIEW       http://stackoverflow.com/questions/29241691/how-do-i-use-uilongpressgesturerecognizer-with-a-uicollectionviewcell-in-swift
        let longPressGR = UILongPressGestureRecognizer(target: self, action: "deleteMeme:")
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        longPressGR.delegate = self
        collectionView?.addGestureRecognizer(longPressGR)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        
    }


    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
   
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return memeCollection.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionCell
    
        cell.imageView.image = memeCollection.memes[indexPath.row].memedImage
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        indexPathRow = indexPath.row
        performSegueWithIdentifier("showDetail", sender: self)
    }
    
    // MARK: - DELETE MEME
    
   func deleteMeme(sender: UILongPressGestureRecognizer) {
        let point = sender.locationInView(collectionView)
        guard let indexPath = collectionView?.indexPathForItemAtPoint(point) else{
            return print("NOT WORKING")
        }
        let alertController = UIAlertController(title: "Delete Meme", message: "Are you sure you want to delete this", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "YUP", style: .Default) { (ACTION) -> Void in
            self.memeCollection.removeMeme(self.memeCollection.memes[indexPath.row])
            self.collectionView?.deleteItemsAtIndexPaths([indexPath])
        }
        let cancelAction = UIAlertAction(title: "Nope", style: .Destructive, handler: nil)
        
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destinationViewController as? detailVC {
                detailVC.indexPathRow = self.indexPathRow
            }
        }
    }

}
