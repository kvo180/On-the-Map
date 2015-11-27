//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Khoa Vo on 11/16/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit
import FBSDKCoreKit

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: - Authenticate Login
    func authenticateLogin(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = UdacityClient.configureURLRequestForPOSTSession(username, password: password)
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let account = result.valueForKey(UdacityClient.JSONResponseKeys.Account) as? NSDictionary {
                    if let userKey = account.valueForKey(UdacityClient.JSONResponseKeys.UserKey) as? String {
                        print("Got userKey: \(userKey)")
                        User.uniqueKey = userKey
                        completionHandler(success: true, errorString: nil)
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.UserKey) in \(account)")
                        completionHandler(success: false, errorString: "User not found.")
                    }
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.UserKey) in \(result)")
                    completionHandler(success: false, errorString: "Account not found.")
                }
            }
        }
    }
    
    
    // MARK: - loginWithFacebook
    func loginWithFacebook(accessToken: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = UdacityClient.configureURLRequestForPOSTFacebookSession(accessToken)
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let account = result.valueForKey(UdacityClient.JSONResponseKeys.Account) as? NSDictionary {
                    if let userKey = account.valueForKey(UdacityClient.JSONResponseKeys.UserKey) as? String {
                        print("Got userKey: \(userKey)")
                        User.uniqueKey = userKey
                        completionHandler(success: true, errorString: nil)
                    } else {
                        print("Could not find \(UdacityClient.JSONResponseKeys.UserKey) in \(account)")
                        completionHandler(success: false, errorString: "User not found.")
                    }
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.UserKey) in \(result)")
                    completionHandler(success: false, errorString: "Account not found.")
                }
            }
        }
    }
    
    
    // MARK: - Get Public User Data
    func getPublicUserData() {
        
        let request = UdacityClient.configureURLRequestForGETUserData()
        
        createDataTask(request) { (result, error) in
            if let error = error {
                print(error)
            } else {
                if let user = result.valueForKey("user") as? NSDictionary {
                    User.lastName = user["last_name"] as! String
                    User.firstName = user["first_name"] as! String
                }
            }
        }
    }
    
    
    // MARK: - Logout of Session
    func logoutSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = UdacityClient.configureURLRequestForDELETESession()
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                // Assume that logout request is successful as long as the result data includes a 'session' dictionary
                let session = result.valueForKey(UdacityClient.JSONResponseKeys.Session) as? NSDictionary
                if session != nil {
                    completionHandler(success: true, errorString: nil)
                } else {
                    print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(result)")
                    completionHandler(success: false, errorString: "Session not found.")
                }
            }
        }
    }
    
}
