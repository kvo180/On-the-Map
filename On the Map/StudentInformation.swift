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
    var createdAt: NSDate!
    var updatedAt: NSDate!
    
    init(dictionary: [String : AnyObject]) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZ"
        
        if let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String {
            self.lastName = lastName
        }
        if let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double {
            self.longitude = longitude
        }
        if let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double {
            self.latitude = latitude
        }
        if let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String {
            self.mapString = mapString
        }
        if let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        }
        if let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        }
        if let objectID = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String {
            self.objectID = objectID
        }
        if let createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String {
            self.createdAt = dateFormatter.dateFromString(createdAt)
        }
        if let updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String {
            self.updatedAt = dateFormatter.dateFromString(updatedAt)
        }
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