//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by John Clema on 18/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        memeImageView.image = meme.editedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("detailToEditor", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailToEditor" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let editorController = navigationController.topViewController         as! MemeEditorViewController
            editorController.meme = meme
        }
    }
}