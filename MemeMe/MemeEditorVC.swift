//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Abdul-Wasai Wasim on 1/25/16.
//  Copyright © 2016 Laylapp. All rights reserved.
//

import UIKit


class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var imageHolder = UIImage()
    private var moveKeyboard = false
    
    //FOR SEGUE FROM DETAILVC
    var editingExistingMeme = false
    var indexPathRow: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
    
       share.enabled = false
       setUpTextFields(topTextField)
       setUpTextFields(bottomTextField)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false{
            camera.enabled = false
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications("keyboardWillShow:", name: UIKeyboardWillShowNotification)
        subscribeToKeyboardNotifications("keyboardWillHide:", name: UIKeyboardWillHideNotification)
        
        if editingExistingMeme {
            let meme = Memes.memeLibrary.memes[indexPathRow]
            topTextField.text = meme.topText
            if imageView.image == nil {
            imageView.image = meme.originalImage
            }
            bottomTextField.text = meme.bottomText
            share.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications(UIKeyboardWillShowNotification)
        unsubscribeFromKeyboardNotifications(UIKeyboardWillHideNotification)
        editingExistingMeme = false
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

    func setUpTextFields (textField: UITextField) {
        let memeTextAttributes: [String: AnyObject] = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0]
        
        //CITE FOR -4.0: http://stackoverflow.com/questions/28006404/how-to-add-outline-to-text-in-a-uitextview
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = self
    }

    func addImage(isCamera isCamera: Bool) {
        let picker = UIImagePickerController()
        if isCamera {
            picker.sourceType = .Camera
        }else{
            picker.sourceType = .PhotoLibrary
        }
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func startCamera(sender: UIBarButtonItem) {
        addImage(isCamera: true)
    }
    
    @IBAction func openAlbum(sender: UIBarButtonItem) {
        addImage(isCamera: false)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - IMAGEPICKER DELEGATE METHODS
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if imageView.image != nil && indexPathRow != -1 {  //THE BOOL CHANGES BACK TO FALSE AFTER RETURNING FROM IMAGEPICKER
            editingExistingMeme = true
        }
        imageView.image = image
        share.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - TEXTFIELD DELEGATE METHODS
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        if textField == bottomTextField {
            moveKeyboard = true
        }else{
            moveKeyboard = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: KEYBOARD RELATED METHODS
    
    func subscribeToKeyboardNotifications(selector: String, name: String) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(selector), name: name, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(name: String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if moveKeyboard {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification)->CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: GENERATE AND SAVE MEME
    func generateMeme ()-> UIImage {
        hideNavToolBar(true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let mImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        hideNavToolBar(false)
        return mImage
    }
    
    func save() {
        let meme = Meme(view: view, topText: topTextField.text!, bottomText: bottomTextField.text!,originalImage: imageView.image!, memedImage:generateMeme())
        if let image = imageView.image {
            imageHolder = image
        }
        imageView.image = meme.memedImage
        
        if editingExistingMeme {
            Memes.memeLibrary.replaceMeme(meme,indexPathRow: indexPathRow)
        }else{
            Memes.memeLibrary.addMeme(meme)
        }
    }
    
    func hideNavToolBar(hide: Bool) {
        navBar.hidden = hide
        toolBar.hidden = hide
    }
    
    //MARK: - SHARE
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        if let image = imageView.image {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityController.completionWithItemsHandler = {(activity, success, array, error) in
              self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.save()
            presentViewController(activityController, animated: true, completion:{self.imageView.image = self.imageHolder})
    }
    }

}

