//
//  ViewController.swift
//  LifeCycle
//
//  Created by Adam Woods on 2017-06-30.
//  Copyright © 2017 Adam Woods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main View did load")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Main View will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Main View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Main View will dissapear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Main View did dissapear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

