//
//  StudentInformation.swift
//  On the Map
//
//  Created by Khoa Vo on 11/17/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: - Properties
    var firstName = ""
    var lastName = ""
    var longitude = 0.0
    var latitude = 0.0
    var mediaURL = ""
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
        if let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        }
        if let updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String {
            self.updatedAt = dateFormatter.dateFromString(updatedAt)
        }
    }
    
}