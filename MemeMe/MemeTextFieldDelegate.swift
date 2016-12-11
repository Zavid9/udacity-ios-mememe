//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Zhang, David on 12/4/16.
//  Copyright © 2016 Zhang, David. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {

    var userHasInputtedText = false
    var defaultText = "DEFAULT"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (!userHasInputtedText) {
            textField.text = "";
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text!.isEmpty) {
            textField.text = defaultText;
            userHasInputtedText = false
        } else {
            userHasInputtedText = true
        }
    }
    
}
