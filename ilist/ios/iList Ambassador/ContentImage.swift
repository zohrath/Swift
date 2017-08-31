//
//  ContentImage.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-07-21.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol ContentImageDelegate {
    func imageLoaded()
}

class ContentImage: UIImageView, ContentView {
    
    var delegate: ContentImageDelegate?
    
    var bottomMarginPercent: CGFloat = 0.0
    var horizontalMarginPercent: CGFloat = 0.0
    var marginEdgePercentage: CGFloat = 0.0
    var view: UIView { return self }
    var height:CGFloat = 0.0
    var width: CGFloat = 0.0
    
    lazy var longpresShare: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(sharePressed(_:)))
        return lp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(urlString: String) {
        self.init(frame: CGRect.zero)
        setImageFromString(urlString)
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
        contentMode = .scaleAspectFit
    }
    
    func prepareForReuse() {
        self.af_cancelImageRequest()
        self.image = nil
    }
    
    func setImageFromStringAndMargin(_ urlString: String, horizontalMarginPercent: CGFloat) {
        self.horizontalMarginPercent = horizontalMarginPercent
        setImageFromString(urlString)
    }
    
    func setImageFromString(_ urlString: String) {
        if let url = URL(string: urlString) {
            af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: true, completion: { (response: DataResponse<UIImage>) in
                
                if let image = response.result.value {
                    let screenWidht = SCREENSIZE.width
                    let width = screenWidht-((self.horizontalMarginPercent/100 * 2) * screenWidht)
                    let height = (width/image.size.width)*image.size.height
                    self.width = width
                    self.height = height
                    self.delegate?.imageLoaded()
                }
            })
        }
    }
    
    func sharePressed(_ sender:UILongPressGestureRecognizer) {
        
    }
}

class ContentFillImage: ContentImage {
    
    override func setup() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
    }
}
