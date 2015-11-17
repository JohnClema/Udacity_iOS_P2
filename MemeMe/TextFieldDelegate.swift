//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by John Clema on 17/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
