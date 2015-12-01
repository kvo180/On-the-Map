//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Khoa Vo on 11/17/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

// MARK: - ParseClient (Convenient Resource Methods) 

extension ParseClient {
    
    // MARK: - GET Student Locations Data
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = ParseClient.configureURLRequestForGETStudentLocations()
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let results = result.valueForKey(ParseClient.JSONResponseKeys.StudentResults) as? [[String : AnyObject]] {
                    
                    Student.studentsFromResults(results)

                    completionHandler(success: true, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.StudentResults) in \(result)")
                    completionHandler(success: false, errorString: "No results returned from server.")
                }
            }
        }
    }
    
    
    // MARK: - POST a Student Location
    func postStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = ParseClient.configureURLRequestForPOSTStudentLocation()
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let objectID = result.valueForKey(ParseClient.JSONResponseKeys.ObjectID) as? String {
                    
                    print("Got objectID: \(objectID)")
                    
                    completionHandler(success: true, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.ObjectID) in \(result)")
                    completionHandler(success: false, errorString: "Could not complete request.")
                }
            }
        }
    }
    
    
    // MARK: Querying for a Student Location
    func queryStudentLocation(completionHandler: (objectIDArray: [String], success: Bool, errorString: String?) -> Void) {
        
        let request = ParseClient.configureURLRequestForQUERYStudentLocation()
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(objectIDArray: [], success: false, errorString: error.localizedDescription)
            } else {
                if let results = result.valueForKey(ParseClient.JSONResponseKeys.StudentResults) as? [[String : AnyObject]] {
                    
                    var objectIDArray = [String]()
                    
                    if !results.isEmpty {
                        
                        // Map objectId strings from results array to objectIDArray
                        objectIDArray = results.map({$0["objectId"] as! String})
                    }
                    
                    completionHandler(objectIDArray: objectIDArray, success: true, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.StudentResults) in \(result)")
                    completionHandler(objectIDArray: [], success: false, errorString: "Could not complete request.")
                }
            }
        }
    }
    
    
    // MARK: - DELETE Student Location
    func deleteStudentLocation(objectIDArray: [String], completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = ParseClient.configureURLRequestForBatchDELETEStudentLocation(objectIDArray)
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let results = result as? [[String : [String : AnyObject]]] {

                    let dictionary = results[0] as NSDictionary
                    if let dict = dictionary.valueForKey("success") as? [String : AnyObject] {
                        print(dict)
                        completionHandler(success: true, errorString: nil)
                    } else {
                        print("Delete request - returned results not empty.")
                        completionHandler(success: false, errorString: "Could not complete request.")
                    }
                    
                } else {
                    print("Delete request failed.")
                    completionHandler(success: false, errorString: "Could not complete request.")
                }
            }
        }
    }
    
    func putStudentLocation(objectID: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = ParseClient.configureURLRequestForPUTStudentLocation(objectID)
        
        createDataTask(request) { (result, error) in
            
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
            } else {
                if let updatedAt = result.valueForKey(ParseClient.JSONResponseKeys.UpdatedAt) as? String {
                    
                    print("Updated at: \(updatedAt)")
                    
                    completionHandler(success: true, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.UpdatedAt) in \(result)")
                    completionHandler(success: false, errorString: "Could not complete request.")
                }
            }
        }
    }
}
