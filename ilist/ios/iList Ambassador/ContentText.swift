//
//  ContentText.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-07-21.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit

class ContentText: UITextView, ContentView {
    
    var horizontalMarginPercent: CGFloat = 0.0
    var bottomMarginPercent: CGFloat = 0.0
    var marginEdgePercentage: CGFloat = 0.0
    var view: UIView { return self }
    var height:CGFloat = 0.0
    var width: CGFloat = 0.0
    
    var color: UIColor = UIColor.white
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(meta: Meta, bottomMarginPercent: CGFloat, horizontalMarginPercent: CGFloat) {
        self.init(frame: CGRect.zero, textContainer: nil)
        self.horizontalMarginPercent = horizontalMarginPercent
        self.bottomMarginPercent = bottomMarginPercent
        self.text = meta.text
        self.font = meta.font
        self.color = meta.color
        self.textAlignment = meta.textAlignment
        setup()
    }

    fileprivate func setup() {
        textColor = self.color
        tintColor = Color.blueColor()
        self.textContainerInset = UIEdgeInsets.zero

        self.isScrollEnabled = false
        self.delegate = self
        self.isEditable = false
        self.isSelectable = true
        self.dataDetectorTypes = .link
        self.linkTextAttributes = [NSForegroundColorAttributeName : Color.lightBlueColor()]
        self.backgroundColor = UIColor.clear
        let screenWidht = SCREENSIZE.width
        let width = screenWidht-((self.horizontalMarginPercent/100 * 2) * screenWidht)
        if let font = self.font {
            if let height = self.text?.heightWithConstrainedWidth(width, font: font) {
                self.height = height
            }
            self.width = width
        }
    }
    
    func prepareForReuse() {
        self.text = nil
    }

    override var canBecomeFirstResponder : Bool {
        return false
    }
    
}

extension ContentText: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}
