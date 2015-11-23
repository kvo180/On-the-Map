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
    
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        
        loadingView.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        loadingView.clipsToBounds = true
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = loadingView.center
        
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        // GET Student Locations
//        refreshDataSet()
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
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
        activityIndicator.startAnimating()
        
        // GET Student Locations
        ParseClient.sharedInstance().getStudentLocations() { (data, success, errorString) in
            if success {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.loadingView.removeFromSuperview()
                    
                    ParseClient.sharedInstance().students = data!
                }
                
                print("Student Locations data downloaded successfully")
                print("tab bar controller: \(ParseClient.sharedInstance().students)")

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
