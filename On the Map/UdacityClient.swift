//
//  UdacityClient.swift
//  On the Map
//
//  Created by Khoa Vo on 11/12/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // MARK: - Properties
    var session: NSURLSession!
    
    override init() {
        super.init()
        session = NSURLSession.sharedSession()
    }
    
    // MARK: - POST
    func authenticateLogin(method: String, userName: String, password: String, completionHandler: (result: AnyObject!, success: Bool, error: NSError?) -> Void) {
        
        /* 1. Set the parameters */
        // No parameters to set...
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            UdacityClient.parseJSONData(newData)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // MARK: - Helpers
    class func parseJSONData(data: NSData) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            print("Coult not parse the data as JSON: \(data)")
        }
        
        if let badCredentials: String? = parsedResult.valueForKey("error") as? String {
            print(badCredentials)
        }
        print(parsedResult)
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
