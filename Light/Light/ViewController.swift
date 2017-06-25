//
//  ViewController.swift
//  Light
//
//  Created by Adam Woods on 2017-06-11.
//  Copyright © 2017 Adam Woods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var lightOn = true

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var lightButton: UIButton!

    @IBAction func buttonPressed(_ sender: Any) {
        lightOn = !lightOn
        updateUI()
    }
    
    func setTitle(_ title: String?, for state: UIControlState) {
        
    }
    
    func updateUI() {
        view.backgroundColor = lightOn ? .white : .black
        }
    }



