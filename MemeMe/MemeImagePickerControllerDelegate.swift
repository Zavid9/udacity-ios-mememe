//
//  MemeImagePickerControllerDelegate.swift
//  MemeMe
//
//  Created by Zhang, David on 12/4/16.
//  Copyright © 2016 Zhang, David. All rights reserved.
//

import Foundation
import UIKit

class MemeImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView: UIImageView?
    var shareButton: UIBarButtonItem?

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView!.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        shareButton?.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        shareButton?.isEnabled = true
    }
    
}
