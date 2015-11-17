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
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var memeImage : UIImage!
    var delegate = TextFieldDelegate()

    var meme : Meme?
    var picker: UIImagePickerController?
    
    // MARK: View Controller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("share:"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel:"))
        
        self.navigationController?.toolbarHidden = false
        
        let font: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        let memeTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSStrokeColorAttributeName: UIColor.blackColor(), NSFontAttributeName : font, NSStrokeWidthAttributeName:2]
        
        self.topTextField.delegate = self.delegate
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.textAlignment = .Center
        self.bottomTextField.delegate = self.delegate
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.textAlignment = .Center
        self.bottomTextField.resignFirstResponder()
        self.topTextField.resignFirstResponder()
    }
    
    
    
    //MARK: Keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        else {
            self.topTextField.resignFirstResponder()
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:  UIKeyboardWillHideNotification, object: nil)

    }
    
    
    //MARK: Top Bar
    
    func share(sender: UIBarButtonItem) {
        memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems:[memeImage!], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func cancel(sender: UIBarButtonItem) {
        
    }
    
    //MARK: Meme
    func save() {
        let meme = Meme( topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, initalImage:
            self.imagePickerView.image!, editedImage: memeImage)
    }
    
    func generateMemedImage() -> UIImage
    {
        // TODO: Hide toolbar and navbar
        
        self.navigationController?.toolbar.hidden = true
        self.navigationController?.navigationBar.hidden = true

        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.navigationController?.toolbar.hidden = false
        self.navigationController?.navigationBar.hidden = false

        return memedImage
    }
    
    //MARK: Bottom Bar
    
    @IBAction func openAlbums(sender: UIBarButtonItem) {
        openPicker(sender, sourceType: .SavedPhotosAlbum)
    }
    
    @IBAction func openCamera(sender: UIBarButtonItem) {
        openPicker(sender, sourceType: .Camera)
    }
    
    
    //MARK: Image Picker
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
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imagePickerView.image = image
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}

