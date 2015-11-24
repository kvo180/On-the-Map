//
//  PostingViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/24/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextView: UITextView!
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure button
        findOnMapButton.layer.cornerRadius = 10.0
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapButtonTouchUp(sender: AnyObject) {
        
        print("findOnMapButton pressed")
    }
}
