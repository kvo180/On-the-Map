//
//  MapViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/14/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var locations: [StudentInformation] = [StudentInformation]()
    @IBOutlet weak var mapView: MKMapView!
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure overlay view and activity indicator
        loadingView.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        loadingView.clipsToBounds = true
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = loadingView.center
    }
    
    // MARK: - Utilities
    
    // Get student locations
    func getStudentData() {
        
        showLoadingOverlayView()
        
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success {
                
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(time, dispatch_get_main_queue()) {

                    self.locations = ParseClient.sharedInstance().students
                    self.configureAnnotations()
                    self.dismissLoadingOverlayView()
                    print("Student Locations data downloaded successfully")
                }
                
            } else {
                
                let alertController = UIAlertController(title: "", message: "\(errorString!)\nPlease try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                alertController.addAction(dismissAction)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissLoadingOverlayView()
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
    
    func configureAnnotations() {

        // If previous annotations exist, remove from map
        let oldAnnotations = mapView.annotations
        if !oldAnnotations.isEmpty {
            mapView.removeAnnotations(oldAnnotations)
            print("Previous annotations removed")
        }
        
        // Create annotations array
        var annotations = [MKPointAnnotation()]

        // Configure annotations
        for studentLocation in locations {

            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            // Create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        print("Annotations added")
    }
    
    // MARK: - MKMapViewDelegate Methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Respond to taps - open URL in browser
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let urlString = view.annotation?.subtitle! {
                
                let url = NSURL(string: urlString)
                let app = UIApplication.sharedApplication()
                
                if app.openURL(url!) {
                    print("URL opened successfully")
                } else {
                    print("URL cannot be opened")
                    
                    let alertController = UIAlertController(title: "", message: "Invalid URL", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                    alertController.addAction(dismissAction)
                    presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
