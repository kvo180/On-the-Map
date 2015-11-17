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
                if let results = result.valueForKey(ParseClient.JSONResponseKeys.Results) as? NSArray {
                    print(results)
                    completionHandler(success: true, errorString: nil)
                } else {
                    print("Could not find \(ParseClient.JSONResponseKeys.Results) in \(result)")
                    completionHandler(success: false, errorString: "No results returned from server.")
                }
            }
        }
    }
    
}
