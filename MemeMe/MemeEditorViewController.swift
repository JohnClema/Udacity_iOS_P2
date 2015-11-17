//
//  ViewController.swift
//  MemeMe
//
//  Created by John Clema on 3/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraBarButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("share:"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancel:"))
        
        navigationController?.toolbarHidden = false
        
        let font: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        let memeTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSStrokeColorAttributeName: UIColor.blackColor(), NSFontAttributeName : font, NSStrokeWidthAttributeName:2]
        
        topTextField.delegate = delegate
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.delegate = delegate
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.resignFirstResponder()
        topTextField.resignFirstResponder()
    }
    
    
    
    //MARK: Keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        else {
            topTextField.resignFirstResponder()
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
        presentViewController(controller, animated: true, completion: nil)
        
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
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, initalImage:
            imagePickerView.image!, editedImage: memeImage)
    }
    
    func generateMemedImage() -> UIImage
    {
        // TODO: Hide toolbar and navbar
        
        navigationController?.toolbar.hidden = true
        navigationController?.navigationBar.hidden = true

        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        navigationController?.toolbar.hidden = false
        navigationController?.navigationBar.hidden = false

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
        picker = UIImagePickerController()
        
        if(UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            picker!.sourceType = sourceType
            picker?.delegate = self
            picker!.mediaTypes = [kUTTypeImage as String]
            picker!.allowsEditing = false
            
            presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info.description)
        print("Image")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}

