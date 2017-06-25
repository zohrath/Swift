//
//  UserTableViewCell.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 21/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let cellIdentifier = "UserTableViewCell"
    
    @IBOutlet weak var profilePictureImageView: ProfilePictureImageView!
    @IBOutlet weak var nameLabel: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = Font.boldFont(FontSize.Large)
        nameLabel.textColor = Color.purpleColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePictureImageView.prepareForReuse()
    }
    
}
