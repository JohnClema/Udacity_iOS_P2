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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        memeImageView.image = meme.editedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "detailToEditor", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToEditor" {
            let navigationController = segue.destination as! UINavigationController
            let editorController = navigationController.topViewController         as! MemeEditorViewController
            editorController.meme = meme
        }
    }
}
