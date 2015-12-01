//
//  TableViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/14/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var studentsTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "getStudentData", forControlEvents: UIControlEvents.ValueChanged)
        studentsTableView.addSubview(refreshControl)
        
        // Configure overlay view and activity indicator
        loadingView.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        loadingView.clipsToBounds = true
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = loadingView.center
    }
    
    // Get student locations
    func getStudentData() {
        
        // If refresh control was used, don't show loading view
        if !refreshControl.refreshing {
            showLoadingOverlayView()
        }
        
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success {
                
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(time, dispatch_get_main_queue()) {
                    
                    self.studentsTableView.reloadData()
                    self.dismissLoadingOverlayView()
                    self.refreshControl.endRefreshing()
                    print("Student Locations data downloaded successfully")
                }
                
            } else {
                
                let alertController = UIAlertController(title: "", message: "\(errorString!).\nPlease try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                alertController.addAction(dismissAction)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissLoadingOverlayView()
                    self.refreshControl.endRefreshing()
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showLoadingOverlayView() {
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingOverlayView() {
        activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    
    // MARK: - UITableViewDelegate and UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Student.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let student = Student.students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableViewCell") as! StudentLocationTableViewCell
        
        // Configure label container view
        cell.labelContainerView.layer.cornerRadius = cell.labelContainerView.frame.size.width / 2
        cell.labelContainerView.clipsToBounds = true
        let labelDiameter = cell.labelContainerView.frame.size.width
        let initialsTextSize = ((labelDiameter / 2) * sqrt(2)) * 0.7
        
        // Get label text values
        let first = student.firstName
        let last = student.lastName
        let mediaURL = student.mediaURL
        let firstInitial = first[first.startIndex]
        let lastInitial = last[last.startIndex]
        
        // Get updatedAt date and configure timezone and date format
        let updateAt = student.updatedAt
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' h:mm a"
        let date = dateFormatter.stringFromDate(updateAt)
        
        // Configure cell views
        cell.nameLabel.text = "\(first) \(last)"
        cell.nameLabel.font = UIFont(name: "Roboto-Regular", size: 18.0)
        cell.urlLabel.text = mediaURL
        cell.urlLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        cell.initialsLabel.text = "\(firstInitial)\(lastInitial)"
        cell.initialsLabel.font = UIFont(name: "Roboto-Regular", size: initialsTextSize)
        cell.updatedAtLabel.text = "Updated \(date)"
        cell.updatedAtLabel.font = UIFont(name: "Roboto-Thin", size: 12.0)

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = studentsTableView.cellForRowAtIndexPath(indexPath) as! StudentLocationTableViewCell
        
        if let urlString = cell.urlLabel.text {
            
            let url = NSURL(string: urlString)
            let app = UIApplication.sharedApplication()
            
            if app.openURL(url!) {
                print("URL opened successfully")
            } else {
                print("URL cannot be opened")
                
                let alertController = UIAlertController(title: "", message: "Invalid URL.", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                alertController.addAction(dismissAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
            
            studentsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
}
