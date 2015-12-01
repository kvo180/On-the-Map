//
//  Student.swift
//  On the Map
//
//  Created by Khoa Vo on 12/1/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//
//  Helper method obtained from TheMovieManager by Jarrod Parkes on 2/11/15.

import Foundation

class Student {
    
    // MARK: - Properties
    static var students: [StudentInformation] = [StudentInformation]()
    
    // MARK: - Helper
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation objects */
    static func studentsFromResults(results: [[String : AnyObject]]) {
        
        students = []
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }

    }
}