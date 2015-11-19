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
        
        self.memeImageView.image = meme.editedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}