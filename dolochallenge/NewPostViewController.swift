//
//  NewPostViewController.swift
//  dolochallenge
//
//  Created by Casey Wilcox on 2/15/18.
//  Copyright © 2018 Casey Wilcox. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var changeLocationLabel: UILabel! // Default - Optional
    
    @IBOutlet weak var headlineTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    var keyboardHeight: CGFloat = -216.0
    var imagePicker = UIImagePickerController()
    var updatedLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyling()
        
        imagePicker.delegate = self
        
        if let location = updatedLocation {
            locationButton.setTitle(location, for: .normal)
        }

        headlineTextView.delegate = self
        bodyTextView.delegate = self
        headlineTextView.text = "Headline"
        bodyTextView.text = "Body"
        headlineTextView.textColor = UIColor.lightGray
        bodyTextView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            keyboardHeight = keyboardHeight * CGFloat(-1.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveButtons(buttons: [self.postButton, self.cancelButton], moveDistance: keyboardHeight, up: true)
        
        if textView == headlineTextView {
            if headlineTextView.text == "Headline" {
                headlineTextView.text = ""
                headlineTextView.textColor = UIColor.black
            }
        } else {
            if bodyTextView.text == "Body" {
                bodyTextView.text = ""
                bodyTextView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveButtons(buttons: [self.postButton, self.cancelButton], moveDistance: keyboardHeight, up: false)
        if headlineTextView.text.isEmpty {
            headlineTextView.text = "Headline"
            headlineTextView.textColor = UIColor.lightGray
            self.postButton.isEnabled = false
        } else {
            self.postButton.isEnabled = true
        }
        
        if textView == headlineTextView {
            if headlineTextView.text.isEmpty {
                headlineTextView.text = "Body"
                headlineTextView.textColor = UIColor.lightGray
            }
        } else {
            if bodyTextView.text.isEmpty {
                bodyTextView.text = "Body"
                bodyTextView.textColor = UIColor.lightGray
            }
        }
    }
    
    func moveButtons(buttons: [UIButton], moveDistance: CGFloat, up: Bool) {
        let moveDuration = 0.25
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateButtons", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.postButton.frame = self.postButton.frame.offsetBy(dx: 0, dy: movement)
        self.cancelButton.frame = self.cancelButton.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.camera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.library()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func camera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have a camera!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func library() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.contentMode = .scaleAspectFit
            selectedImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPushed(_ sender: Any) {
        postButton.layer.borderColor = UIColor.purple.cgColor
        postButton.layer.borderWidth = 1
        postButton.layer.cornerRadius = 15
        postButton.tintColor = UIColor.purple
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "post" {
            let home = segue.destination as? HomeViewController
            home?.showCheckmark = true
        }
    }
    
    func buttonStyling() {
        postButton.layer.borderColor = UIColor.lightGray.cgColor
        postButton.layer.borderWidth = 1
        postButton.layer.cornerRadius = 15
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 15
        
    }
    
}
