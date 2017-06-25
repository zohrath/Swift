//
//  CircularImageView.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 06/03/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {

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
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width/2.0
    }

}
