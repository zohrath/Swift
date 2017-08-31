//
//  SecondViewController.swift
//  LifeCycle
//
//  Created by Adam Woods on 2017-06-30.
//  Copyright © 2017 Adam Woods. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Secondary view did load")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Secondary View will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Secondary View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Secondary View will dissapear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Secondary View did dissapear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
