//
//  InfoButton.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 06/03/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit

class InfoButton: UIButton {
    
    fileprivate final let titleTextAttributes = [
        NSForegroundColorAttributeName : Color.blueColor(),
        NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20.0)
    ]
    fileprivate final let subtitleTextAttributes = [
        NSForegroundColorAttributeName : Color.blueColor(),
        NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)
    ]
    
    // MARK: - View life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
    }

    // MARK: - Layout
    
    func updateWithTitle(_ title: String, subtitle: String?) {
        let attributedString = NSMutableAttributedString()

        let attributedTitleString = NSAttributedString(string: title, attributes: titleTextAttributes)
        attributedString.append(attributedTitleString)
        
        if let subtitle = subtitle {
            let attributedSubtitleString = NSAttributedString(string: "\n" + subtitle, attributes: subtitleTextAttributes)
            attributedString.append(attributedSubtitleString)
        }

        setAttributedTitle(attributedString, for: UIControlState())
    }
    
}

