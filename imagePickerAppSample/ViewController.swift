//
//  ViewController.swift
//  imagePickerAppSample
//
//  Created by Arnab Roy on 4/25/18.
//  Copyright © 2018 RoyInc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imagePIckerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    
    @IBOutlet weak var shareViewBar: UIToolbar!
    @IBOutlet weak var imageViewBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func clickToShare(_ sender: Any) {
        
        // Generate a memed image
        let memeImage:UIImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC,animated: true,completion: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            // User completed activity
            self.ClearMeme((Any).self)
        }
        
    }
    
    @IBAction func ClearMeme(_ sender: Any) {
        reset()
        imagePIckerView.image = nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePIckerView.image = image
        }
        dismiss(animated: true, completion: nil)
        if imagePIckerView.image == nil{
            shareMeme.isEnabled = false
        }
        else{
            shareMeme.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ bottomTextField: UITextField) -> Bool {
        bottomTextField.resignFirstResponder()
        return true
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        _ = Meme(topTextFieldText: topTextField.text!, bottomTextFieldText: bottomTextField.text!, originalImage: imagePIckerView.image!, memImage: memedImage)
        
        print("end of Save method")
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.shareViewBar.isHidden = true
        self.imageViewBar.isHidden = true
        self.navigationController?.isToolbarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.shareViewBar.isHidden = false
        self.imageViewBar.isHidden = false
        return memedImage
    }
    
    func  reset() {
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: 2.0]
        topTextField.text = "Top"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        
        bottomTextField.text = "Bottom"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        imagePIckerView.image = nil
        if imagePIckerView.image == nil{
            shareMeme.isEnabled = false
        }
        
    }
}

