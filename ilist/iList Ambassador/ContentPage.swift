//
//  ContentPage.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 21/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation
    
private let kAPIKeyId = "id"
private let kAPIKeyBackgrounds = "backgrounds"
private let kAPIKeyComponents = "components"
private let kAPIKeyOrder = "order"
private let kAPIKeyContent = "content"
private let kAPIKeyCreated = "created"
private let kAPIKeyUpdated = "updated"

open class ContentPage {
    
    var id: Int = 0
    var background: ContentPageBackground?
    var components: [ContentPageComponent]
    
    var order: Int = 0
    var content: Int = 0
    
    var created: Date?
    var updated: Date?

    init(dictionary: [String:Any]) {
        if let id = dictionary[kAPIKeyId] as? Int {
            self.id = id
        }
        if let backgroundsArray = dictionary[kAPIKeyBackgrounds] as? Array<[String:Any]> {
            if let background = backgroundsArray.first {
                self.background = ContentPageBackground(dictionary: background)
            }
        }
        if let componentsArray = dictionary[kAPIKeyComponents] as? Array<[String:Any]> {
            self.components = componentsArray.map({ ContentPageComponent(dictionary: $0) }).sorted(by: { $0.order < $1.order })
        } else {
            self.components = []
        }
        if let order = dictionary[kAPIKeyOrder] as? Int {
            self.order = order
        }
        if let content = dictionary[kAPIKeyContent] as? Int {
            self.content = content
        }
        if let createdString = dictionary[kAPIKeyCreated] as? String, let createdDate = NSDate(string: createdString, formatString: APIDefinitions.FullDateFormat) {
            created = createdDate as Date
        }
        if let updatedString = dictionary[kAPIKeyUpdated] as? String, let updatedDate = NSDate(string: updatedString, formatString: APIDefinitions.FullDateFormat) {
            updated = updatedDate as Date
        }
    }
    
}
