//
//  ParseConstants.swift
//  On the Map
//
//  Created by Khoa Vo on 11/17/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: URLs
        static let baseURLSecure: String = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: - Authentication
        
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Students
        static let StudentResults = "results"
        static let UpdatedAt = "updatedAt"
        static let Longitude = "longitude"
        static let Latitude = "latitude"
        static let ObjectID = "objectId"
        static let LastName = "lastName"
        static let FirstName = "firstName"
        static let CreatedAt = "createdAt"
        static let MediaURL = "mediaURL"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
    }
}
