//
//  StudentInformation.swift
//  On the Map
//
//  Created by Khoa Vo on 11/17/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//
//  Helper method obtained from TheMovieManager by Jarrod Parkes on 2/11/15.

import Foundation

struct StudentInformation {
    
    // MARK: - Properties
    
    var firstName = ""
    var lastName = ""
    var longitude = 0.0
    var latitude = 0.0
    var mapString = ""
    var mediaURL = ""
    var uniqueKey = ""
    var objectID = ""
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    init(dictionary: [String : AnyObject]) {
        
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
    
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation objects */
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
    
}