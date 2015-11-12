//
//  LoginViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/8/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    let emailPlaceholderText = "Email"
    let passwordPlaceholderText = "Password"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
        
        emailLoginTextField.text = emailPlaceholderText
        passwordLoginTextField.text = passwordPlaceholderText
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    // MARK: - IBActions

    @IBAction func loginButtonPressed(sender: AnyObject) {
        print("logged in")
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
        let signUpPageURL = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.sharedApplication().openURL(signUpPageURL!)

    }
    
    @IBAction func facebookSignInButtonPressed(sender: AnyObject) {
    }
    
    // MARK: - Utilities
    // Close keyboard whenever user taps anywhere outside of keyboard:
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - UITextField Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // If placeholder text is displayed, empty textfield when beginning editing
        if textField == emailLoginTextField && textField.text == emailPlaceholderText {
            textField.text = ""
        }
        else if textField == passwordLoginTextField && textField.text == passwordPlaceholderText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        // If textField is empty, show respective default placeholder text
        if textField.text == "" {
            if textField == emailLoginTextField {
                textField.text = emailPlaceholderText
            }
            else {
                textField.text = passwordPlaceholderText
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}