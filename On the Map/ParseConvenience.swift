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
                    
                    let students = StudentInformation.studentsFromResults(results)
                    self.students = students

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
                    completionHandler(success: false, errorString: "Could not complete request. \nPlease try again.")
                }
            }
        }
    }
    
}
