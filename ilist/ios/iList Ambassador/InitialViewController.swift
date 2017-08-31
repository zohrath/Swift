//
//  InitialViewController.swift
//  iList Ambassador
//
//  Created by Adam Woods on 2017-07-23.
//  Copyright © 2017 iList AB. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    fileprivate weak var newProfileViewController: NewProfileViewController!
    fileprivate weak var menuViewController: RotatingMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue", let menuViewController = segue.destination as? RotatingMenuViewController {
            self.menuViewController = menuViewController
            self.menuViewController.delegate = self
        } else if segue.identifier == "RootSegue", let destination = segue.destination as? UINavigationController, let newProfileViewController = destination.topViewController as? NewProfileViewController {
            self.newProfileViewController = newProfileViewController
            self.newProfileViewController.delegate = self
        }
    }

}

extension InitialViewController: RotatingMenuViewControllerDelegate, setProfilePicDelegate {
    func showRewards() {
        
    }

    func showProfile() {
        self.newProfileViewController.showProfile()
    }

    func menuAction(segue: String) {
        self.newProfileViewController.menuAction(segue: segue)
    }
    
    func selectedAmbassadorship(ambassadorShip: Ambassadorship) {
        self.newProfileViewController.selectedAmbassadorship(ambassadorShip: ambassadorShip)
    }
    
    func setProfilePictureForMenu(_ image: UIImage) {
        self.menuViewController.setProfilePictureForMenu(image)
    }
}
