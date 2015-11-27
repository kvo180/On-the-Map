//
//  ParseClient.swift
//  On the Map
//
//  Created by Khoa Vo on 11/17/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    // MARK: - Properties
    var session: NSURLSession!
    
    var students: [StudentInformation] = [StudentInformation]()
    
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
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    
                    let localizedResponse = NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
                    print("Your request returned an invalid response! Status code: \(response.statusCode). Description: \(localizedResponse).")
                    
                    let userInfo = [NSLocalizedDescriptionKey : "\(response.statusCode) - \(localizedResponse)"]
                    completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo))
                    
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    let userInfo = [NSLocalizedDescriptionKey : "The request returned an invalid response code"]
                    completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo))
                    
                } else {
                    print("Your request returned an invalid response!")
                    let userInfo = [NSLocalizedDescriptionKey : "The request returned an invalid response code"]
                    completionHandler(result: nil, error: NSError(domain: "statusCode", code: 2, userInfo: userInfo))
                }
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                let userInfo = [NSLocalizedDescriptionKey : "Unable to retrieve data from server"]
                completionHandler(result: nil, error: NSError(domain: "data", code: 3, userInfo: userInfo))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            UdacityClient.parseJSONDataWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
    // MARK: - Configure URL Requests
    class func configureURLRequestForGETStudentLocations() -> NSMutableURLRequest {
        /* 1. Set the parameters */
        let parameters: [String : AnyObject] = [
            ParameterKeys.Limit: 100,
            ParameterKeys.Order: ParameterKeys.UpdatedAtDescending
        ]
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + Methods.ClassLevelOperation + UdacityClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    class func configureURLRequestForPOSTStudentLocation() -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        // No parameters to set...
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + Methods.ClassLevelOperation
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(User.uniqueKey)\", \"firstName\": \"\(User.firstName)\", \"lastName\": \"\(User.lastName)\",\"mapString\": \"\(User.mapString)\", \"mediaURL\": \"\(User.mediaURL)\",\"latitude\": \(User.latitude), \"longitude\": \(User.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
    }
    
    class func configureURLRequestForQUERYStudentLocation() -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        let queryString = "{\"\(JSONResponseKeys.UniqueKey)\":\"\(User.uniqueKey)\"}"
        let escapedQueryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + Methods.ClassLevelOperation + Methods.QueryParameter + escapedQueryString!
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    class func configureURLRequestForBatchDELETEStudentLocation(objectIDArray: [String]) -> NSMutableURLRequest {
        
        /* 1. Set the parameters */

        // Initialize empty array of strings
        var requestsArray = [String]()
        
        var array = objectIDArray
        array.removeFirst()
        
        // Add each objectID (except for most recent) to requestDictionary and append to requestsArray
        for objectID in array {
            let requestDictionary = "{\"method\": \"DELETE\", \"path\": \"/1\(Methods.ClassLevelOperation)/\(objectID)\"}"
            requestsArray.append(requestDictionary)
        }
        // Get string representation of requestsArray to be used in HTTPBody
        let requestsArrayString = requestsArray.joinWithSeparator(", ")
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.baseURLSecure + Methods.BatchOperation
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"requests\": [\(requestsArrayString)]}".dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}

