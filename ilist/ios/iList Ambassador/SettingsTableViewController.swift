//
//  SettingsTableViewController.swift
//  iList Ambassador
//
//  Created by Adam Woods on 2017-08-20.
//  Copyright © 2017 iList AB. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare


class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    
    @IBAction func x(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: .zero)
        print(user?.searchable! ?? "Could not print searchable")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let destination = segue.destination as! EditProfileViewController
            destination.user = user
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                let activityVC = UIActivityViewController(activityItems: [NSLocalizedString("ILIST_SHARE_LINK", comment: "")], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.excludedActivityTypes = [
                    UIActivityType.airDrop, UIActivityType.mail,
                    UIActivityType.openInIBooks, UIActivityType.postToFacebook, UIActivityType.postToFlickr,
                    UIActivityType.postToTencentWeibo, UIActivityType.postToTwitter, UIActivityType.postToVimeo,
                    UIActivityType.postToWeibo, UIActivityType.print, UIActivityType.saveToCameraRoll
                ]
                self.present(activityVC, animated: true, completion: nil)
                
            case 1:
                performSegue(withIdentifier: "editProfileSegue", sender: self)
                
            case 2:
                //Edit password segue
                break
            case 3:
                showUserAgreements()
            case 4:
                presentContactMailComposer()
            case 5:
                showAboutiList()
            case 6:
                promptLogoutUser()
            default:
                break
            }
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        default:
            return 0
        }
    }
    
    // TODO: Privacy policy?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Settings", for: indexPath) as! SettingsCell
        cell.backgroundColor = .white
        cell.cellButton.setImage(#imageLiteral(resourceName: "right").withRenderingMode(.alwaysOriginal), for: .normal)
        cell.cellButton.imageView?.contentMode = .scaleAspectFit
        cell.closeButton.imageView?.contentMode = .scaleAspectFit
        cell.closeButton.isHidden = true
        
        if indexPath.section == 0 {
            cell.cellButton.isHidden = true
            cell.closeButton.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
            cell.closeButton.isHidden = false
        } else if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                cell.labelText = NSLocalizedString("TELL_A_FRIEND", comment: "")
            case 1:
                cell.labelText = NSLocalizedString("EDIT PROFILE", comment: "")
                
            case 2:
                cell.labelText = NSLocalizedString("EDIT PASSWORD", comment: "")
                
            case 3:
                cell.labelText = NSLocalizedString("USER_AGREEMENTS", comment: "")
                
            case 4:
                cell.labelText = NSLocalizedString("CONTACT", comment: "")
                
            case 5:
                cell.labelText = NSLocalizedString("ABOUT_ILIST", comment: "")
                
                
            case 6:
                cell.labelText = NSLocalizedString("LOGOUT", comment: "")
                
            default:
                break
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.textColor = Color.ilistBackgroundColor()
        
        if section == 1 {
            label.text = NSLocalizedString("SETTINGS", comment: "")
        }
        
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return NSLocalizedString("SETTINGS", comment: "")
        default:
            return ""
        }
    }
    
    fileprivate func showUserAgreements() {
        let urlString = NSLocalizedString("URL_AGREEMENTS", comment: "")
        if let url = URL(string: urlString) {
            if #available(iOS 9.0, *) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            // TODO: Statistics send log event for url opened
        }
    }
    
    fileprivate func promptLogoutUser() {
        let alertController = UIAlertController(title: NSLocalizedString("LOGOUT", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title:  NSLocalizedString("LOGOUT", comment: ""), style: UIAlertActionStyle.destructive, handler: { (alertAction: UIAlertAction) in
            self.logoutUser()
        }))
        
        alertController.addAction(UIAlertAction(title:  NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel, handler: { (alertAction: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }

    fileprivate func logoutUser() {
        UserManager.sharedInstance.logoutUserWithCompletion {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.navigateToLogin()
            }
        }
    }
    
    fileprivate func showAboutiList() {
        let urlString = NSLocalizedString("URL_WEBSITE", comment: "")
        if let url = URL(string: urlString) {
            if #available(iOS 9.0, *) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            // TODO: Statistics send log event for url opened
        }
    }

    fileprivate func presentContactMailComposer() {
        presentMailControllerWithEmail(NSLocalizedString("ILIST_CONTACT_MAIL", comment: ""), subject: nil)
    }
    
    fileprivate func presentMailControllerWithEmail(_ emailAddress:String, subject:String?) {
        let messageComposerController = MFMailComposeViewController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        messageComposerController.extendedLayoutIncludesOpaqueBars = true
        messageComposerController.mailComposeDelegate = self
        messageComposerController.setToRecipients([emailAddress])
        if let subject = subject{
            messageComposerController.setSubject(subject)
        }
        present(messageComposerController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
