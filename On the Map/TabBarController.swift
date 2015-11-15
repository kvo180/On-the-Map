//
//  TabBarController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/14/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        /* Create and set the navigation bar buttons */
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonPressed")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshDataSet")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "presentPostingView")
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
    }
    
    // MARK: - Utilities
    func logoutButtonPressed() {
        print("Logout button pressed")
    }
    
    func refreshDataSet() {
        print("data set refreshed")
    }
    
    func presentPostingView() {
        print("Posting view presented")
    }
}
