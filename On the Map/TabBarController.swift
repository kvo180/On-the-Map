//
//  TabBarController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/14/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class TabBarController: UITabBarController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        
        /* Create and set the left navigation bar buttons */
        // Check if FB Access token exists, then create corresponding bar button
        if FBSDKAccessToken.currentAccessToken() != nil {
            let fbButtonRect = CGRectMake(0.0, 0.0, 84.0, 30.0)
            let fbButton = FBSDKLoginButton(frame: fbButtonRect)
            fbButton.delegate = self
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: fbButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonTouchUp")
        }
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshDataSet")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "presentPostingView")
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
    
        // GET Student Locations
        refreshDataSet()
    }
    
    // MARK: - Bar Button Actions
    func logoutButtonTouchUp() {
        let confirmLogoutController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .Destructive) { action in
            self.deleteCurrentSession()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        confirmLogoutController.addAction(logoutAction)
        confirmLogoutController.addAction(cancelAction)
        
        presentViewController(confirmLogoutController, animated: true, completion: nil)
    }

    func refreshDataSet() {
        
        // GET Student Locations
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success {
                print("Student Locations data downloaded successfully")
            } else {
                
                let alertController = UIAlertController(title: "", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                alertController.addAction(okAction)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func presentPostingView() {
        print("Posting view presented")
    }
    
    // MARK: - Facebook Login Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        // This method is not needed in this view controller
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Facebook logged out")
        deleteCurrentSession()
    }
    
    // MARK: - Utilities
    func deleteCurrentSession() {
        UdacityClient.sharedInstance().logoutSession() { (success, errorString) in
            if success {
                print("Logout successful")
                self.completeLogout()
            } else {
                print(errorString)
            }
        }
    }
    
    func completeLogout() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
