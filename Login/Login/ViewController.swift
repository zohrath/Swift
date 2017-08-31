//
//  ViewController.swift
//  Login
//
//  Created by Adam Woods on 2017-06-28.
//  Copyright © 2017 Adam Woods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var forgotUsername: UIButton!
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        
        if sender == forgotPassword {
            segue.destination.navigationItem.title = "Forgot Password"
        }else if sender == forgotUsername {
            segue.destination.navigationItem.title = "Forgot Username"
        }else {
            segue.destination.navigationItem.title = Username.text
        }
        
        
        
    }
    
    @IBAction func tappedForgotUsernameButton(_ sender: UIButton) {
        performSegue(withIdentifier: "fromLoginScreenToLandingScreen", sender: forgotUsername)
    }
    @IBAction func tappedForgotPasswordBUtton(_ sender: UIButton) {
        performSegue(withIdentifier: "fromLoginScreenToLandingScreen", sender: forgotPassword)
    }
}

