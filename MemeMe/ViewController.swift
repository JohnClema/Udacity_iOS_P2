//
//  ViewController.swift
//  MemeMe
//
//  Created by John Clema on 3/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var albumsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    
    
    var imageData : Meme?
    var picker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("share:"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel:"))
        
        self.navigationController?.toolbarHidden = false
        
        
//        self.setToolbarItems([camera, albums], animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func share(sender: UIBarButtonItem) {
        print("Hello")
    }
    
    func cancel(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func openAlbums(sender: UIBarButtonItem) {
        openPicker(sender, sourceType: .SavedPhotosAlbum)
    }
    
    @IBAction func openCamera(sender: UIBarButtonItem) {
        openPicker(sender, sourceType: .Camera)
    }
    
    func openPicker(sender: UIBarButtonItem, sourceType: UIImagePickerControllerSourceType) {
        self.picker = UIImagePickerController()

        if(UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            self.picker!.sourceType = sourceType
            self.picker?.delegate = self
            self.picker!.mediaTypes = [kUTTypeImage as String]
            self.picker!.allowsEditing = false

            self.presentViewController(self.picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info.description)
        print("Image")
        imageData?.initalImage = info.indexForKey("UIImagePickerControllerOriginalImage") as UIImage
    }

}

