//
//  TableViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/14/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("table view did load")
    }
    
    func getStudentData() {
        print("table view refresh button pressed")
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableViewCell") as UITableViewCell!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("row selected: \(indexPath.row)")
    }
    
}
