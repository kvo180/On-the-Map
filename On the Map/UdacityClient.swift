//
//  UdacityClient.swift
//  On the Map
//
//  Created by Khoa Vo on 11/12/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class UdacityClient: NSObject {
    
    // MARK: - Properties
    var session: NSURLSession!
    var userKey: String? = nil
    
    // MARK: - Initializers
    override init() {
        super.init()
        session = NSURLSession.sharedSession()
    }
    
    // MARK: - dataTaskWithRequest
    func createDataTask(request: NSMutableURLRequest, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                let userInfo = [NSLocalizedDescriptionKey : "Unable to retrieve data from server."]
                completionHandler(result: nil, error: NSError(domain: "data", code: 3, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                let userInfo = [NSLocalizedDescriptionKey : "Email/Password is invalid."]
                completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo)) // Optimize error description!!!!!!!
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            UdacityClient.parseJSONDataWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // MARK: - Helpers
    class func configureURLRequestForPOSTSession(userName: String, password: String) -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        // No parameters to set...
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + UdacityClient.Methods.AuthenticationSession
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
    }
    
    class func configureURLRequestForDELETESession() -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        // No parameters to set...
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + UdacityClient.Methods.AuthenticationSession
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return request
    }
    
    class func configureURLRequestForPOSTFacebookSession(accessToken: String) -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        // No parameters to set...
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + UdacityClient.Methods.AuthenticationSession
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
    }
    
    class func configureURLRequestForGETUserData() -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        // No parameters to set...
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + UdacityClient.Methods.UserAccount + "/" + UdacityClient.sharedInstance().userKey!
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        return request
    }
    
    class func parseJSONDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
