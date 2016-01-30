//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/28/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesTableVC: UITableViewController {

    private let memeCollection = Memes.memeLibrary
    private var indexPathRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - TableView dataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memeCollection.memes.count)
        return memeCollection.memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
        let memes = memeCollection.memes[indexPath.row]
        cell.memeImageView.image = memes.memedImage
        cell.memeTextLabel.text = "\(memes.topText) \(memes.bottomText)"

        print(memes)
        return cell
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            memeCollection.removeMeme(memeCollection.memes[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexPathRow = indexPath.row
        performSegueWithIdentifier("showDetail", sender: self)
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showDetail" {
            if let detailVC = segue.destinationViewController as? detailVC {
                detailVC.indexPathRow = indexPathRow
            }
        }
    }


}
