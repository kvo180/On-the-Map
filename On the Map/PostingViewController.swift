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
    @IBOutlet weak var userLocationMapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    let locationTextViewPlaceholderText = "Enter your location..."
    let URLTextViewPlaceholderText = "Enter a link to share..."
    let URLTextViewProtocolText = "https://"
    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
    let darkBlueColor = UIColor(red: 30/255, green: 65/255, blue: 139/255, alpha: 1.0)
    let lightGrayColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    var userLatitude: Double!
    var userLongitude: Double!
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure container views
        postLocationContainerView.hidden = false
        postURLContainerView.hidden = true
        
        // Configure textviews
        locationTextView.delegate = self
        locationTextView.textContainerInset = UIEdgeInsetsMake(15.0, 5.0, 10.0, 5.0)
        URLTextView.delegate = self
        let topInset = (URLTextView.bounds.height - 20.0) / 2
        URLTextView.textContainerInset = UIEdgeInsetsMake(topInset, 5.0, 10.0, 5.0)
        
        // Configure buttons
        findOnMapButton.layer.cornerRadius = 10.0
        submitButton.layer.cornerRadius = 10.0
        cancelButton.setTitleColor(darkBlueColor, forState: .Normal)
        
        // Add tap recognizers
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapButtonTouchUp(sender: AnyObject) {
        
        if locationTextView.text != locationTextViewPlaceholderText {
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationTextView.text) { (placemarkArray, error) in
                
                if error == nil {
                    
                    let userPlacemark = placemarkArray![0]
                    
                    // Get user string coordinates and store into properties
                    self.userLatitude = userPlacemark.location?.coordinate.latitude
                    self.userLongitude = userPlacemark.location?.coordinate.longitude
  
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
    
    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        
        if URLTextView.text != URLTextViewPlaceholderText {
            
            print("post submitted")
            // ONLY dismiss VC if post is successful. If failed, display alert controller
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        else {
            
            let alertController = UIAlertController(title: "", message: "Please enter a valid link.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Utilities
    
    func showPostURLContainerView(userPlacemark: CLPlacemark) {
        
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
        
        // Hide postLocationContainerView
        postLocationContainerView.hidden = true
        
        // Configure and show postURLContainerView
        cancelButton.setTitleColor(lightGrayColor, forState: .Normal)
        postURLContainerView.hidden = false
        userLocationMapView.showAnnotations(annotations, animated: true)
        userLocationMapView.selectAnnotation(annotation, animated: true)
        userLocationMapView.setRegion(region, animated: true)
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
