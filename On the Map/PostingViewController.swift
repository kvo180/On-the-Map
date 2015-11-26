//
//  PostingViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/24/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ContactsUI

class PostingViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var postLocationContainerView: UIView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var postURLContainerView: UIView!
    @IBOutlet weak var URLTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userLocationMapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var defaultRegion: MKCoordinateRegion!
    let locationTextViewPlaceholderText = "Enter your location..."
    let URLTextViewPlaceholderText = "Enter a link to share..."
    let URLTextViewProtocolText = "https://"
    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
    let darkBlueColor = UIColor(red: 30/255, green: 65/255, blue: 139/255, alpha: 1.0)
    let lightGrayColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure container views
        postLocationContainerView.hidden = false
        postLocationContainerView.alpha = 1
        postURLContainerView.hidden = true
        postURLContainerView.alpha = 0
        
        // Configure textviews
        locationTextView.delegate = self
        locationTextView.textContainerInset = UIEdgeInsetsMake(15.0, 5.0, 10.0, 5.0)
        URLTextView.delegate = self
        let topInset = (URLTextView.bounds.height - 20.0) / 2
        URLTextView.textContainerInset = UIEdgeInsetsMake(topInset, 5.0, 10.0, 5.0)
        
        // Get mapview default region
        defaultRegion = userLocationMapView.region
        
        // Configure buttons
        findOnMapButton.layer.cornerRadius = 10.0
        submitButton.layer.cornerRadius = 10.0
        cancelButton.setTitleColor(darkBlueColor, forState: .Normal)
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - IBActions
    
    // Forward geocode user location and show post URL view
    @IBAction func findOnMapButtonTouchUp(sender: AnyObject) {
        
        if locationTextView.text != locationTextViewPlaceholderText {
            
            // Get user mapString and store into property
            User.mapString = locationTextView.text!
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationTextView.text) { (placemarkArray, error) in
                
                if error == nil {
                    
                    let userPlacemark = placemarkArray![0]
                    
                    // Get user string coordinates and store into properties
                    User.latitude = (userPlacemark.location?.coordinate.latitude)!
                    User.longitude = (userPlacemark.location?.coordinate.longitude)!

                    self.showPostURLContainerView(userPlacemark)
                }
                
                else {
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                    alertController.addAction(dismissAction)
                    
                    if error!.domain == kCLErrorDomain && error!.code == 8 {
                        
                        alertController.message = "Location cannot be found."
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                    else {
                        
                        alertController.message = error!.localizedDescription
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
            
        else {
            
            let alertController = UIAlertController(title: "", message: "Please enter a location.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Go back to post location view
    @IBAction func backButtonTouchUp(sender: AnyObject) {
        
        dismissKeyboard()
        
        // postURLContainerView transition animation
        UIView.animateWithDuration(0.4, animations: {
            self.postURLContainerView.alpha = 0
        })
        
        // Configure and show postLocationContainerView
        cancelButton.setTitleColor(darkBlueColor, forState: .Normal)
        postLocationContainerView.hidden = false
        postLocationContainerView.alpha = 1
        
        // Hide postURLContainerView with delay so animation is visible
        let delay = 0.4 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            self.postURLContainerView.hidden = true
        }
    }
    
    // Submit user location post
    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        
        if URLTextView.text != URLTextViewPlaceholderText {
            
            // Get user mediaURL and store into property
            User.mediaURL = URLTextView.text!
            
            ParseClient.sharedInstance().postStudentLocation() { (success, errorString) in
                if success {
                    
                    print("Student location successfully posted.")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                
                else {
                    
                    let alertController = UIAlertController(title: "", message: "\(errorString!)\nPlease try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
                    alertController.addAction(dismissAction)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        else {
            
            let alertController = UIAlertController(title: "", message: "Please enter a valid link.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissKeyboard()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Utilities
    
    func showPostURLContainerView(userPlacemark: CLPlacemark) {
        
        // Reset mapview
        userLocationMapView.setRegion(defaultRegion, animated: false)
        let previousAnnotations = userLocationMapView.annotations
        if !previousAnnotations.isEmpty {
            userLocationMapView.removeAnnotations(previousAnnotations)
        }
        
        // Configure mapview region
        let coordinate = userPlacemark.location!.coordinate
        let circularRegion = userPlacemark.region as! CLCircularRegion
        let metersAcross = circularRegion.radius * 2
        let region = MKCoordinateRegionMakeWithDistance(coordinate, metersAcross, metersAcross)
        
        // Configure address string
        let addressDictionary = userPlacemark.addressDictionary as! [String : AnyObject]
        var addressLinesArray = addressDictionary["FormattedAddressLines"] as! [String]
        let addressTitle = addressLinesArray.removeFirst()
        let addressSubtitle = addressLinesArray.joinWithSeparator(", ")
        
        // Configure annotations array for userLocationMapView
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = addressTitle
        annotation.subtitle = addressSubtitle
        annotations.append(annotation)

        // Configure and show postURLContainerView
        cancelButton.setTitleColor(lightGrayColor, forState: .Normal)
        postURLContainerView.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.postURLContainerView.alpha = 1
        })
        userLocationMapView.showAnnotations(annotations, animated: true)
        userLocationMapView.selectAnnotation(annotation, animated: true)
        userLocationMapView.setRegion(region, animated: true)
        
        // Hide postLocationContainerView with delay so animation is visible
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            
            self.postLocationContainerView.hidden = true
            self.postLocationContainerView.alpha = 0
        }
    }
    
    // Close keyboard whenever user taps anywhere outside of keyboard:
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Dismiss keyboard if Return key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    // MARK: - TextView Delegate Methods
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == locationTextViewPlaceholderText {
            textView.text = ""
        }
        else if textView.text == URLTextViewPlaceholderText {
            textView.text = URLTextViewProtocolText
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == locationTextView {
            if textView.text.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
                textView.text = locationTextViewPlaceholderText
            }
        }
        else {
            if textView.text.stringByTrimmingCharactersInSet(whitespaceSet) == "" || textView.text == URLTextViewProtocolText {
                textView.text = URLTextViewPlaceholderText
            }
        }
    }

}
