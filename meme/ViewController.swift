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
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
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
        
        if(botText.isFirstResponder){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    // MARK: save&share image
    func save()  {
        let memmedImage = generateMemedImage()
        _ = Meme(topText: topText.text!, bottomText: botText.text!, originalImage: ImageView.image!, memedImage: memmedImage)
    }
    
    func generateMemedImage() -> UIImage {
        toolBar.isHidden = true
        navBar.isHidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        navBar.isHidden = false
        return memedImage
    }
    
    @IBAction func share(_ sender: Any ){
        let memedImage: UIImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    //MARK: pick photo
    
    func pick(sourceType:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pick(sourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    // MARK: textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Top" || textField.text == "Bottom"{
        textField.text = ""}
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
}

