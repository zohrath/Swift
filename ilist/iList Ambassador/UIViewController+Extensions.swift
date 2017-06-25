//
//  UIViewController+Extensions.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 2017-01-05.
//  Copyright © 2017 iList AB. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func showErrorAlert(withMessage message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("ERROR", comment: ""), message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action: UIAlertAction) in
            alertController.dismiss(animated: true)
        }))
        present(alertController, animated: true)
    }
    
}
