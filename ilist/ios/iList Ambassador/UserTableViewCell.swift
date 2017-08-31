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
        backgroundColor = .white
        nameLabel.font = Font.boldFont(FontSize.Large)
        nameLabel.textColor = Color.ilistBackgroundColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePictureImageView.prepareForReuse()
    }
    
}
