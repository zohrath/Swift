//
//  NavigationBar.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 09/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import FontAwesomeKit

let navigationBarIconSize = CGFloat(22.0)

class NavigationBar: UINavigationBar {
    
    // Views
    lazy var navigationBarSeparator: UIImageView? = {
        for view in self.subviews {
            for view2 in view.subviews {
                if let view2 = view2 as? UIImageView {
                    return view2
                }
            }
        }
        return nil
    }()
    
    // Properties
    static let titleAttributes = [
        NSForegroundColorAttributeName: Color.blueColor(),
        NSFontAttributeName: Font.titleFont(FontSize.ExtraLarge)
    ]
    
    static let subtitleAttributes = [
        NSForegroundColorAttributeName: Color.blackColor(),
        NSFontAttributeName: Font.normalFont(FontSize.Normal)
    ]
    
    static let barButtonAttributes = [
        NSForegroundColorAttributeName : Color.blueColor(),
        NSFontAttributeName : Font.normalFont(FontSize.Normal)
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
        NavigationBar.styleNavigationBar(self)
    }
    
    class func styleNavigationBar(_ navigationBar: UINavigationBar) {
        navigationBar.isTranslucent = false
        
        navigationBar.barTintColor = Color.whiteColor()
        navigationBar.tintColor = Color.blueColor()
        
        navigationBar.titleTextAttributes = titleAttributes
        
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: UIControlState())
        
        // Custom back button
        var backButtonImage = UIImage(named: "backarrow")
        backButtonImage = backButtonImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationBar.backIndicatorImage = backButtonImage
        navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        // Bottom separator color
        //        navigationBarSeparator?.backgroundColor = Color.veryLightGrayColor()
        
        
        // Remove back button title
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: UIBarMetrics.default)

    }
    
    func labelForTitle(_ title: String, subtitle: String) -> UILabel {
        let subviewFrame = self.bounds.insetBy(dx: 8, dy: 0)
        
        let titleLabel = UILabel(frame: subviewFrame)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: title, attributes: NavigationBar.titleAttributes))
        attributedString.append(NSAttributedString(string: "\n", attributes: NavigationBar.subtitleAttributes))
        attributedString.append(NSAttributedString(string: subtitle, attributes: NavigationBar.subtitleAttributes))
        
        
        
        let style = NSMutableParagraphStyle()
        //        style.lineSpacing = 24
        style.lineHeightMultiple = 0.8
        style.alignment = .center
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(title.characters.count+1, subtitle.characters.count))
        
        titleLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        
        return titleLabel
    }
    
    // MARK: - Help functions
    
    class func closeButtonWithTarget(_ target: AnyObject?, action: Selector) -> UIBarButtonItem {
//        let closeIcon = FAKFontAwesome.closeIconWithSize(navigationBarIconSize)
//        let closeImage = closeIcon.imageWithSize(CGSizeMake(closeIcon.iconFontSize, closeIcon.iconFontSize))
        let closeImage = UIImage(named: "close_small")
        return UIBarButtonItem(image: closeImage, style: .plain, target: target, action: action)
    }
}

