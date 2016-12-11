//
//  ViewController.swift
//  MemeMe
//
//  Created by Zhang, David on 12/4/16.
//  Copyright © 2016 Zhang, David. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var footerStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeImagePickerControllerDelegate = MemeImagePickerControllerDelegate()
    let topTextFieldDelegate = MemeTextFieldDelegate()
    let bottomTextFieldDelegate = MemeTextFieldDelegate()
    var isAlreadyEditting = false;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImagePickerControllerDelegate.imageView = memeView
        memeImagePickerControllerDelegate.shareButton = shareButton
        shareButton.isEnabled = false
        setUpTextField(topTextField, defaultText:"TOP", delegate:topTextFieldDelegate)
        setUpTextField(bottomTextField, defaultText:"BOTTOM", delegate:bottomTextFieldDelegate)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func pickAlbumImage(_ sender: Any) {
        pickImage(.photoLibrary);
    }
    
    @IBAction func pickCameraImage(_ sender: Any) {
        pickImage(.camera);
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        cancelButton.isEnabled = false;
        if (bottomTextField.isEditing && !isAlreadyEditting) {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            isAlreadyEditting = true;
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        cancelButton.isEnabled = true;
        if (isAlreadyEditting) {
            view.frame.origin.y = 0
            isAlreadyEditting = false;
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func pickImage(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = memeImagePickerControllerDelegate
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setUpTextField(_ textField: UITextField, defaultText: String, delegate: MemeTextFieldDelegate) {
        delegate.defaultText = defaultText
        textField.delegate = delegate

        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5.0]
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center;
        textField.textAlignment = NSTextAlignment.center;
    }

    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (type, completed, items, error) in
            if completed {
                self.save(memedImage)
                // TODO: this will be useful in MemeMe v2.0
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func save(_ image: UIImage) {
        // create the meme
        _ = Meme(topText: topTextField.text!,
                        bottomText: bottomTextField.text!,
                        originalImage: memeView.image!,
                        memedImage: image)
    }
    
    func generateMemedImage() -> UIImage {
        
        // hide toolbar and navbar
        headerStackView.isHidden = true;
        footerStackView.isHidden = true;
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        headerStackView.isHidden = false;
        footerStackView.isHidden = false;
        
        return memedImage
    }
    
    @IBAction func cancel(_ sender: Any) {
        setInitialAppState();
    }
    
    func setInitialAppState() {
        isAlreadyEditting = false;
        shareButton.isEnabled = false
        topTextField.text = "TOP";
        topTextFieldDelegate.userHasInputtedText = false;
        bottomTextField.text = "BOTTOM";
        bottomTextFieldDelegate.userHasInputtedText = false;
        memeView.image = nil;
    }

}

