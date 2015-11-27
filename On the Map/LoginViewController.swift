//
//  LoginViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/8/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure login button
        loginButton.layer.cornerRadius = 3
        
        // Configure Facebook login button
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
        
        // Set text field delegates
        emailLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
        
        // Initialize activity indicator
        activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Check if FB access token exists. If true, implement login to Udacity
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            
            startActivityIndicator()
            loginWithFB(accessToken)
            
        } else {
            print("Facebook not logged in...")
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        
        // Make sure login text fields aren't empty or only whitespaces
        if emailLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != "" && passwordLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            
            startActivityIndicator()
            loginButton.enabled = false // Disable loginButton to prevent multiple instances of NSURLRequests
            
            UdacityClient.sharedInstance().authenticateLogin(emailLoginTextField.text!, password: passwordLoginTextField.text!)  { (success, errorString) in
                if success {
                    print("Login successful")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dismissKeyboard()
                        self.completeLogin()
                        self.stopActivityIndicator()
                        self.loginButton.enabled = true
                        self.emailLoginTextField.text = nil
                        self.passwordLoginTextField.text = nil
                        }
                } else {
                    self.showAlertController("\(errorString!).\nPlease try again.")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.stopActivityIndicator()
                        self.loginButton.enabled = true
                    }
                }
            }
        } else {
            if emailLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" && passwordLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
                showAlertController("Please enter your login information.")
            } else if emailLoginTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
                showAlertController("Please enter your email.")
            } else {
                showAlertController("Please enter your password.")
            }
        }
    }
    
    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        
        let signUpPageURL = NSURL(string: UdacityClient.Constants.signUpURL)
        UIApplication.sharedApplication().openURL(signUpPageURL!)
        
    }
    
    
    // MARK: - Utilities
    
    func showAlertController(message: String) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.message = message
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Close keyboard whenever user taps anywhere outside of keyboard:
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func startActivityIndicator() {
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
    }
    
    func completeLogin() {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocationsNavigationController") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Facebook Login Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        startActivityIndicator()
        
        if error != nil {
            print(error.localizedDescription)
            showAlertController(error.localizedDescription)
            stopActivityIndicator()
            return
        } else if result.isCancelled {
            print("Facebook login canceled")
            stopActivityIndicator()
        } else {
            if let accessToken = result.token {
                loginWithFB(accessToken)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // This method is not needed in this view controller
    }
    
    // Helper
    func loginWithFB(accessToken: FBSDKAccessToken) {
        UdacityClient.sharedInstance().loginWithFacebook(accessToken.tokenString) { (success, errorString) in
            if success {
                print("Login with Facebook successful")
                dispatch_async(dispatch_get_main_queue()) {
                    self.completeLogin()
                    self.stopActivityIndicator()
                }
            } else {
                let errorMessage = "An error occurred with Facebook login: \(errorString!).\nPlease try again."
                self.showAlertController(errorMessage)
                dispatch_async(dispatch_get_main_queue()) {
                    self.stopActivityIndicator()
                }
            }
        }
    }
    
    
    // MARK: - UITextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

