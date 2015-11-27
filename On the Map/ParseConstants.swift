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
        
        // MARK: API
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let baseURLSecure: String = "https://api.parse.com/1"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Class-Level Operation
        static let ClassLevelOperation = "/classes/StudentLocation"
        
        // MARK: Batch Operation
        static let BatchOperation = "/batch"
        
        // MARK: Query
        static let QueryParameter = "?where="
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let UpdatedAtDescending = "-updatedAt"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Students
        static let StudentResults = "results"
        static let UpdatedAt = "updatedAt"
        static let Longitude = "longitude"
        static let Latitude = "latitude"
        static let LastName = "lastName"
        static let FirstName = "firstName"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
    }
}
