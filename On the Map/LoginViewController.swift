//
//  LoginViewController.swift
//  On the Map
//
//  Created by Khoa Vo on 11/8/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        print("logged in")
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        print("signed up")
    }
    

    @IBAction func facebookSignInButtonPressed(sender: AnyObject) {
    }

}

