//
//  ContentInboxViewController.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 27/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit

class ContentInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContentLabel: UILabel!
    
    // MARK: Data
    var inbox: [Inbox]? {
        didSet {
            if let activities = inbox {
                noContentLabel.isHidden = activities.count > 0
                tableView.reloadData()
            } else {
                noContentLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("INBOX", comment: "")
        noContentLabel.font = Font.normalFont(16.0)
        noContentLabel.textColor = Color.whiteColor()
        noContentLabel.text = NSLocalizedString("NO_INBOX_YET", comment: "")
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: ContentTableViewCell.cellIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUsersReceivedContent()
    }
    
    fileprivate func updateUsersReceivedContent() {
        ContentManager.sharedInstance.getInbox({inbox, error in
            guard inbox != nil else {
                return
            }
            self.inbox = inbox
        })
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @IBAction func dismissViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate/UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let inbox = inbox {
            return inbox.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewStyler.defaultUserCellHeight * 2.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.cellIdentifier, for: indexPath) as! ContentTableViewCell
        if let inbox = inbox {
            let inbox = inbox[indexPath.row]
            cell.updateWithContent(inbox)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let inbox = inbox {
            let inbox = inbox[indexPath.row]
            if let id = inbox.contentId {
                let contentViewController = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: "ContentController") as! ContentSetupViewController
                contentViewController.contentId = id
                if let imgString = inbox.brandImg {
                    contentViewController.setBrandImg(imgString)
                }
                present(contentViewController, animated: true, completion: nil)

            }
        }
    }
    
}
