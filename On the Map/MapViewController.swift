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
    
    var locations: [StudentInformation] = [StudentInformation]()
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentData()
    }
    
    // Get student locations
    func getStudentData() {
        
        ParseClient.sharedInstance().getStudentLocations() { (data, success, errorString) in
            if success {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.locations = data!
                    self.configureAnnotations()
                    print("Student Locations data downloaded successfully")
                }
                
            } else {
                
                let alertController = UIAlertController(title: "", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                alertController.addAction(okAction)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func configureAnnotations() {
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
            
            if let url = view.annotation?.subtitle! {
                
                UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            }
        }
    }
    
}
