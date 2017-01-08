//
//  ViewController.swift
//  Test
//
//  Created by 政达 何 on 2017/1/8.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var botText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var ImageView: UIImageView!
    struct Meme{
        let topText:String
        let bottomText:String
        let originalImage: UIImage
        let memedImage: UIImage
    }

    func setupTextField(textField: UITextField) {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.clear,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: NSNumber(value: -3.0)]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.text = "Top"
        botText.text = "Bottom"
        setupTextField(textField: topText)
        setupTextField(textField: botText)
        shareButton.isEnabled = false
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save()  {
        let memmedImage = generateMemedImage()
        let meme = Meme(topText: topText.text!, bottomText: botText.text!, originalImage: ImageView.image!, memedImage: memmedImage)
    }
    
    func generateMemedImage() -> UIImage {
        toolBar.isHidden = true
        navBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        navBar.isHidden = false
        return memedImage
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func share(_ sender: Any ){
        print ("share")
        let memedImage: UIImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.image = image
            shareButton.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Top" || textField.text == "Bottom"{
        textField.text = ""}
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
}

