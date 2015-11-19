//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by John Clema on 18/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    var segueMeme: Meme!
    var deleteIndex: NSIndexPath!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if memes.count == 0 {
            performSegueWithIdentifier("presentMemeEditor", sender: self)
        }
        tableView.reloadData()
    }
    
    //MARK: Tableview delegate/datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.editedImage
        cell.memeLabel.text = "\(meme.topText) ... \(meme.bottomText)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        segueMeme = memes[indexPath!.row]
            
        
        performSegueWithIdentifier("showDetailFromTable", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showDetailFromTable") {
            let vc = segue.destinationViewController as! MemeDetailViewController
            vc.meme = segueMeme
        }
        
    }
    
    //MARK: Navigation Buttons
    @IBAction func editButtonPressed(sender: AnyObject) {
        editing = tableView.editing ? false : true
        tableView.setEditing(editing, animated: true)
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("presentMemeEditor", sender: self)
    }
    
    

}