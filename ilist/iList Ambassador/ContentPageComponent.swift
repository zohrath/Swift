//
//  ContentPageComponent.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 21/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import AVFoundation
import UIKit

private let kAPIKeyId = "id"
private let kAPIKeyType = "type"
private let kAPIKeyFile = "file"
private let kAPIKeyThumb = "thumbnail"
private let kAPIKeyMarginHorizontalPercent = "margin_horizontal"
private let kAPIKeyMarginBottomPercent = "margin_bottom"
private let kAPIKeyMarginEdgePercentage = "margin_edge_percentage"

private let kAPIKeyMeta = "meta"
private let kAPIKeyOrder = "order"
private let kAPIKeyContentPage = "content_page"
private let kAPIKeyCreated = "created"
private let kAPIKeyUpdated = "updated"

//META
private let kAPIKeyMetaFontWeight = "font_weight"
//Font Weights
    private let bold = "bold"
    private let italic = "italic"
    private let semiTitle = "semi-title"
    private let title = "title"
private let kAPIKeyMetaTextAlign = "text_align"
private let kAPIKeyMetaFontSize = "font_size"
private let kAPIKeyMetaColor = "color"
private let kAPIKeyMetaText = "text"
private let kAPIKeyMetaHeight = "height"
private let kAPIKeyMetaWidth = "width"

open class ContentPageComponent {
    
    var id: Int = 0
    var type: ContentPageComponentType
    var file: String?
    var thumb: String?
    var meta: Meta?
    var order: Int = 0
    var contentPage: Int = 0
    
    var marginHorizontalPercent: CGFloat = 0.0
    var marginBottomPercent: CGFloat = 0.0
    var marginEdgePercentage: CGFloat = 0.0
    
    var created: Date?
    var updated: Date?
    
    init(dictionary: [String:Any]) {

        if let id = dictionary[kAPIKeyId] as? Int {
            self.id = id
        }
        self.type = ContentPageComponentType(rawValue: dictionary[kAPIKeyType] as! String)!
        
        if let file = dictionary[kAPIKeyFile] as? String {
            if self.type == .Video || self.type == .Sound {
                self.file = file
                let item = AVPlayerItem(url: URL(string: file)!)
                let player = Player(playerItem: item)
                MPCacher.sharedInstance.setObjectForKey(player, key: file)
            } else {
                self.file = file
            }
        }
        if let thumb = dictionary[kAPIKeyThumb] as? String {
            self.thumb = thumb
        }

        if let meta = dictionary[kAPIKeyMeta] as? [String:Any] {
            
            var color = UIColor.black
            var text = ""
            if let metaDataText = meta[kAPIKeyMetaText] as? String {
                text = metaDataText
            }
            var fontSize:CGFloat = 14.0
            if let metaDataColor = meta[kAPIKeyMetaColor] as? String {
                color = UIColor(hexString: metaDataColor)
            }
            if let metaDataFontSize = meta[kAPIKeyMetaFontSize] as? String {
                fontSize = CGFloat(NSString(string: metaDataFontSize).floatValue)
            }
            var font = Font.normalFont(fontSize)
            if let metaDataFontWeight = meta[kAPIKeyMetaFontWeight] as? String {
                switch metaDataFontWeight {
                case bold:
                    font = Font.boldFont(fontSize)
                case italic:
                    font = Font.italicFont(fontSize)
                case semiTitle:
                    font = Font.semiTitleFont(fontSize)
                case title:
                    font = Font.titleFont(fontSize)
                default:
                    break
                }
            }
            var height:CGFloat = 0.0
            if let metaDataHeight = meta[kAPIKeyMetaHeight] as? String {
                height = CGFloat(NSString(string: metaDataHeight).floatValue)
            }
            var width:CGFloat = 0.0
            if let metaDataWidth = meta[kAPIKeyMetaWidth] as? String {
                width = CGFloat(NSString(string: metaDataWidth).floatValue)
            }
            var textAlignment = NSTextAlignment.center
            if let alignmentString = meta[kAPIKeyMetaTextAlign] as? String {
                switch alignmentString {
                case "left":
                    textAlignment = .left
                case "center":
                    textAlignment = .center
                case "right":
                    textAlignment = .right
                default:
                    break
                }
            }
            self.meta = Meta(font: font, size: fontSize, color: color, text: text, height: height, width: width, textAlignment: textAlignment)
        }
        
        if let order = dictionary[kAPIKeyOrder] as? Int {
            self.order = order
        }
        
        if let contentPage = dictionary[kAPIKeyContentPage] as? Int {
            self.contentPage = contentPage
        }
        
        if let marginHorizontalPercent = dictionary[kAPIKeyMarginHorizontalPercent] as? Float {
            self.marginHorizontalPercent = CGFloat(marginHorizontalPercent)
        }
        
        if let marginBottom = dictionary[kAPIKeyMarginBottomPercent] as? Float {
            self.marginBottomPercent = CGFloat(marginBottom)
        }

        if let createdString = dictionary[kAPIKeyCreated] as? String, let createdDate = NSDate(string: createdString, formatString: APIDefinitions.FullDateFormat) {
            created = createdDate as Date
        }
        
        if let updatedString = dictionary[kAPIKeyUpdated] as? String, let updatedDate = NSDate(string: updatedString, formatString: APIDefinitions.FullDateFormat) {
            updated = updatedDate as Date
        }
    }
}

struct Meta {
    var font: UIFont
    var size: CGFloat
    var color: UIColor
    var text: String
    var height: CGFloat
    var width: CGFloat
    var textAlignment: NSTextAlignment

    init(font: UIFont, size: CGFloat, color: UIColor, text: String, height: CGFloat, width: CGFloat, textAlignment: NSTextAlignment) {
        self.font = font
        self.size = size
        self.color = color
        self.text = text
        self.height = height
        self.width = width
        self.textAlignment = textAlignment
    }
}








