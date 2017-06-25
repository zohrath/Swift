//
//  SearchViewController.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 19/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import Crashlytics

class SearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var users: [User]?
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateButton: Button!
    
    var searchTextField: TextField = {
        let textField = TextField(frame: CGRect.zero)
        textField.autoresizingMask = [.flexibleWidth]
        textField.placeholder = NSLocalizedString("SEARCH_USERS_PLACEHOLDER", comment: "")
        textField.returnKeyType = .search
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.backgroundColorDark()
        
        navigationItem.title = NSLocalizedString("CONNECTIONS", comment: "")
        
        searchTextField.delegate = self
        searchTextField.editingDidChangeBlock = searchTextFieldDidChange
        if let navigationBar = navigationController?.navigationBar {
            searchTextField.frame = navigationBar.bounds
            searchTextField.frame.size.height = 32.0
        }
        navigationItem.titleView = searchTextField
        
        tableView.register(UINib(nibName: UserTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView()
        
        emptyStateLabel.font = Font.boldFont(16.0)
        emptyStateLabel.textColor = Color.textColorDark()
        emptyStateButton.setTitle(NSLocalizedString("INVITE_A_FRIEND", comment: ""), for: UIControlState())
        
        checkEmptyState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    // MARK: - Connections
    
    fileprivate func searchUserWithQuery(_ query: String) {
        searchActivityIndicatorView.startAnimating()
        UserManager.sharedInstance.searchUsersWithQuery(query, page: 1, pageSize: 20, completion: { (users, error) in
            self.searchActivityIndicatorView.stopAnimating()
            if let users = users {
                self.users = users
                self.tableView.reloadData()
                self.checkEmptyState()
            } else if let error = error {
                Crashlytics.sharedInstance().recordError(error)
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func emptyStateButtonTapped(_ sender: AnyObject) {
        let shareLinkString = NSLocalizedString("ILIST_SHARE_LINK", comment: "")
        if let linkUrl = URL(string: shareLinkString) {
            let objectsToShare = [linkUrl, shareLinkString] as [Any]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.print, UIActivityType.assignToContact]
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func navigateToUser(_ user: User) {
        if let profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            profileViewController.user = user
            let rootNavigationController = RootNavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
            rootNavigationController.viewControllers = [profileViewController]
            rootNavigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(rootNavigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Empty state
    
    func checkEmptyState() {
        if let users = users {
            emptyStateLabel.text = NSLocalizedString("EMPTY_SEARCH_INFO", comment: "")
            emptyStateView.isHidden = users.count > 0
        } else {
            emptyStateLabel.text = NSLocalizedString("EMPTY_SEARCH_INFO_NO_SEARCH", comment: "")
            emptyStateView.isHidden = false
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = users {
            return users.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewStyler.defaultUserCellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        TableViewStyler.removeSeparatorInsetsForCell(cell)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier, for: indexPath) as! UserTableViewCell
        if let users = users {
            let user = users[indexPath.row]
            cell.nameLabel.text = user.fullName
            
            if let profilePictureString = user.profileImage, let profilePictureUrl = URL(string: profilePictureString) {
                cell.profilePictureImageView.setImageFromUrl(profilePictureUrl)
            } else {
                cell.profilePictureImageView.setDefaultImageForUser(user)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let users = users {
            let user = users[indexPath.row]
            navigateToUser(user)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func searchTextFieldDidChange(_ textField: UITextField) {
        users = []
        tableView.reloadData()
        if let query = textField.text, query.characters.count > 2 {
            searchUserWithQuery(query)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        searchTextField.resignFirstResponder()
        return true
    }

}
