//
//  ViewController.swift
//  Beertastic
//
//  Created by Adam Woods on 2018-03-15.
//  Copyright © 2018 Adam Woods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    // TODO: Log in using Facebook
    @IBAction func facebookLoginButtonPressed(_ sender: UIButton) {
        
    }
    
    // TODO: Log in using Google
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
        
    }
    
    // TODO: Log in using username and password
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
    }
    
    // TODO: Go to forgot password view controller
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        signupButton.imageView?.contentMode = .scaleAspectFit
        signupButton.backgroundColor = .orange
    }


}

