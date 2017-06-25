//
//  ViewController.swift
//  button
//
//  Created by Adam Woods on 2017-06-19.
//  Copyright © 2017 Adam Woods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // UI buttons etc
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Button was tapped")
        
        print(toggle.isOn ? "The switch is on" : "The switch is off")
        
        print("The slider is set to \(slider.value)")
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        print(sender.isOn ? "The switch is on" : "The switch is off")
        
    }
    @IBAction func sliderValueChanged(_ sender:UISlider) {
        print(sender.value)
    }
    @IBAction func keyboardReturnKeyTapped(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
        }
    }
    @IBAction func textChanged(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
        }
    }
    @IBAction func respondToTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        print(location)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

