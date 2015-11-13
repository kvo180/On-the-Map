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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
    let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)

    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
        
        activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Add alert controller action
        let okAction = UIAlertAction(title: "Dismiss", style: .Default) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
    }

    // MARK: - IBActions

    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        // Make sure login text fields aren't empty or only whitespaces
        if emailLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != "" && passwordLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().authenticateLogin(emailLoginTextField.text!, password: passwordLoginTextField.text!)  { (success, errorString) in
                if success {
                    print("Login successful")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicator.alpha = 0.0
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.alertController.message = "Username/Password is invalid."
                        self.presentViewController(self.alertController, animated: true, completion: nil)
                        self.activityIndicator.alpha = 0.0
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            if emailLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" && passwordLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
                alertController.message = "Email/Password is empty."
            } else if emailLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
                alertController.message = "Email is empty."
            } else {
                alertController.message = "Password is empty."
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}