//
//  PostingViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/24/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit
import CoreLocation

class PostingViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextView: UITextView!
    let locationTextViewPlaceholderText = "Enter your location..."
    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
    var userLatitude: Double!
    var userLongitude: Double!
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure textview
        locationTextView.delegate = self
        locationTextView.textContainerInset = UIEdgeInsetsMake(15.0, 5.0, 10.0, 5.0)
        
        // Configure button
        findOnMapButton.layer.cornerRadius = 10.0
        
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
                    self.userLatitude = userPlacemark.location?.coordinate.latitude
                    self.userLongitude = userPlacemark.location?.coordinate.longitude
                    print(self.userLatitude)
                    print(self.userLongitude)
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
    
    // MARK: - Utilities
    
    // Close keyboard whenever user taps anywhere outside of keyboard:
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - TextView Delegate Methods
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == locationTextViewPlaceholderText {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
            textView.text = locationTextViewPlaceholderText
        }
    }
    
    // Dismiss keyboard if Return key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
