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
    
    // MARK: - Properties
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the navigation bar buttons */
        // Check if FB Access token exists, then create corresponding 'Logout' bar button
        if FBSDKAccessToken.currentAccessToken() != nil {
            let fbButtonRect = CGRectMake(0.0, 0.0, 84.0, 30.0)
            let fbButton = FBSDKLoginButton(frame: fbButtonRect)
            fbButton.delegate = self
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: fbButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonTouchUp")
        }
        
        // Create 'Add Pin' and 'Refresh' bar buttons
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshDataSet")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "postButtonTouchUp")
        tabBarController?.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        // Configure overlay view and activity indicator
        loadingView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0)
        loadingView.layer.cornerRadius = 15.0
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        loadingView.clipsToBounds = true
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = loadingView.center
        
        // Get user data
        UdacityClient.sharedInstance().getPublicUserData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // GET Student Locations
        if ParseClient.sharedInstance().students.isEmpty {
            let mapVC = viewControllers![0] as! MapViewController
            mapVC.getStudentData()
        }
        else {
            refreshDataSet()
        }
    }
    
    
    // MARK: - Bar Button Actions
    func logoutButtonTouchUp() {
        let confirmLogoutController = UIAlertController(title: "", message: "Logged in as \(User.firstName) \(User.lastName)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .Destructive) { action in
            self.deleteCurrentSession()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        confirmLogoutController.addAction(logoutAction)
        confirmLogoutController.addAction(cancelAction)
        
        // Clear out stored Student Information array
        ParseClient.sharedInstance().students = []
        
        presentViewController(confirmLogoutController, animated: true, completion: nil)
    }

    func refreshDataSet() {
        
        let mapVC = self.viewControllers![0] as! MapViewController
        mapVC.getStudentData()
        
        let tableVC = self.viewControllers![1] as! TableViewController
        tableVC.getStudentData()
    }
    
    func postButtonTouchUp() {
        
        showActivityIndicator()
        
        ParseClient.sharedInstance().queryStudentLocation() { (objectIDArray, success, errorString) in
            
            if success {
                
                print(objectIDArray)
                
                if objectIDArray.count > 1 {
                
                    // Delete all but the first objectID
                    ParseClient.sharedInstance().deleteStudentLocation(objectIDArray) { (success, errorString) in
                        
                        if success {
                            print("All posts (except most recent) successfully deleted")
                            
                            // Show alert view to confirm overwrite of previous Student Location
                            let confirmString = "User \"\(User.firstName) \(User.lastName)\" has already posted a Student Location. Would you like to overwrite it?"
                            self.showAlertController("confirm", message: confirmString, objectIDArray: objectIDArray)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.hideActivityIndicator()
                            }
                            
                        } else {
                            print("Delete failed")
                            
                            self.showAlertController("error", message: "\(errorString!).\nPlease try again.", objectIDArray: [])
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.hideActivityIndicator()
                            }
                        }
                    }
                }
                    
                else if objectIDArray.count == 1 {
                    print("Only one post found")
                    
                    // Show alert view to confirm overwrite of previous Student Location
                    let confirmString = "User \"\(User.firstName) \(User.lastName)\" has already posted a Student Location. Would you like to overwrite it?"
                    self.showAlertController("confirm", message: confirmString, objectIDArray: objectIDArray)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hideActivityIndicator()
                    }
                    
                }
                else {
                    print("No posts found")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hideActivityIndicator()
                    }
                    self.presentPostingVC(objectIDArray)
                }
            }
            
            else {
                self.showAlertController("error", message: "\(errorString!).\nPlease try again.", objectIDArray: [])
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    
    // MARK: - Facebook Login Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        // This method is not needed in this view controller
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        // Clear out stored Student Information array
        ParseClient.sharedInstance().students = []
        
        print("Facebook logged out")
        deleteCurrentSession()
    }
    
    
    // MARK: - Utilities
    func presentPostingVC(objectIDArray: [String]) {
        
        let postingVC = storyboard?.instantiateViewControllerWithIdentifier("PostingViewController") as! PostingViewController
        postingVC.objectIDArray = objectIDArray
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(postingVC, animated: true, completion: nil)
        }
        
        print("Posting view presented")
    }
    
    func showAlertController(type: String, message: String, objectIDArray: [String]) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.message = message
        
        if type == "confirm" {
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .Destructive, handler: {
                alertAction in
                self.presentPostingVC(objectIDArray)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertController.addAction(overwriteAction)
            alertController.addAction(cancelAction)
            
        } else if type == "error" {
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func showActivityIndicator() {
        
        activityIndicator.startAnimating()
        view.addSubview(loadingView)
        view.addSubview(activityIndicator)
    }
    
    func hideActivityIndicator() {
        
        activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
        activityIndicator.removeFromSuperview()
    }
    
    func deleteCurrentSession() {
        UdacityClient.sharedInstance().logoutSession() { (success, errorString) in
            if success {
                print("Logout successful")
                self.completeLogout()
            } else {
                print(errorString!)
            }
        }
    }
    
    func completeLogout() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
