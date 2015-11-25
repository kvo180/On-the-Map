//
//  PostingViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/24/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextView: UITextView!
    let locationTextViewPlaceholderText = "Enter your location..."
    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
    
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
            
            print("findOnMapButton")
        }
            
        else {
            
            let alertController = UIAlertController(title: "", message: "Please enter a location.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
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
