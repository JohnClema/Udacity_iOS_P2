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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MemeEditorViewController.share(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MemeEditorViewController.cancel(_:)))
        
//        navigationController?.toolbarHidden = false
        
        prepareTextField(topTextField, defaultText: "TOP")
        prepareTextField(bottomTextField, defaultText: "BOTTOM")
        
        if meme != nil {
            imagePickerView.image = meme?.initalImage
            topTextField.placeholder = nil
            bottomTextField.placeholder = nil
            topTextField.text = meme?.topText
            bottomTextField.text = meme?.bottomText
        }
    }
    
    func prepareTextField(_ textField: UITextField, defaultText: String) {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0
        ] as [String : Any]
        textField.delegate = delegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
    }
    
    
    //MARK: Keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y  = 0
        }
        else {
            topTextField.resignFirstResponder()
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: Top Bar
    
    func share(_ sender: UIBarButtonItem) {
        memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems:[memeImage!], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activity, completed, items, error) -> Void in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        //Create the meme
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, initalImage:
            imagePickerView.image!, editedImage: memeImage)

        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK: Meme
    
    func generateMemedImage() -> UIImage
    {
        // TODO: Hide toolbar and navbar
        
        navigationController?.toolbar.isHidden = true
        navigationController?.navigationBar.isHidden = true

        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        navigationController?.toolbar.isHidden = false
        navigationController?.navigationBar.isHidden = false

        return memedImage
    }
    
    //MARK: Bottom Bar
    
    @IBAction func openAlbums(_ sender: Any) {
        openPicker(sender, sourceType: .savedPhotosAlbum)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        openPicker(sender, sourceType: .camera)
    }
    
    
    //MARK: Image Picker
    func openPicker(_ sender: Any, sourceType: UIImagePickerControllerSourceType) {
        self.picker = UIImagePickerController()
        
        if(UIImagePickerController.isSourceTypeAvailable(sourceType))
        {
            picker!.sourceType = sourceType
            picker?.delegate = self
            picker!.mediaTypes = [(kUTTypeImage as String)]
            picker!.allowsEditing = false
            self.present(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info.description)
        print("Image")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
        
    }
}

