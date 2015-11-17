//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Khoa Vo on 11/12/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

extension UdacityClient {
    
    // MARK: - Constants 
    struct Constants {
        
        // MARK: API Keys
        
        // MARK: URLs
        static let baseURLSecure: String = "https://www.udacity.com/api/"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSession = "session"
        
        // MARK: GET Account
        static let UserAccount = "users"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Account
        static let Account = "account"
        static let Registered = "registered"
        static let UserKey = "key"
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
        static let Expiration = "expiration"
    }

}
