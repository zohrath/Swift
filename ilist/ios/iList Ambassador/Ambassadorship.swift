//
//  Ambassadorship.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 31/03/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation
import Social

private let kAPIKeyId = "id"
private let kAPIKeyBrand = "brand"
private let kAPIKeyUserId = "user"
private let kAPIKeyStatus = "status"
private let kAPIKeyCreated = "created"
private let kAPIKeyUpdated = "updated"
private let kAPIKeyAcceptedAt = "accepted_at"

public enum AmbassadorshipStatus: String {
    case pending = "pending"
    case accepted = "accepted"
    case rejected = "rejected"
    case disabled = "disabled"
}

open class Ambassadorship {
    
    var id: Int = 0
    var brand: Brand
    var userId: Int = 0
    var status: AmbassadorshipStatus
    
    var created: Date?
    var updated: Date?
    var acceptedAt: Date?
    
    init(dictionary: [String:Any]) {
        id = dictionary[kAPIKeyId] as! Int
        brand = Brand(dictionary: dictionary[kAPIKeyBrand] as! [String:Any])
        userId = dictionary[kAPIKeyUserId] as! Int
        status = AmbassadorshipStatus(rawValue: dictionary[kAPIKeyStatus] as! String)!
        
        if let created = dictionary[kAPIKeyCreated] as? String {
            self.created = NSDate(string: created, formatString: APIDefinitions.FullDateFormat) as Date?
        }
        if let updated = dictionary[kAPIKeyUpdated] as? String {
            self.updated = NSDate(string: updated, formatString: APIDefinitions.FullDateFormat) as Date?
        }
        if let acceptedAt = dictionary[kAPIKeyAcceptedAt] as? String {
            self.acceptedAt = NSDate(string: acceptedAt, formatString: APIDefinitions.FullDateFormat) as Date?
        }
    }
    
    func toDictionary() -> [String:Any] {
        var dict: [String: AnyObject] = [:]
        
        dict[kAPIKeyId] = id as AnyObject?
//        dict[kAPIKeyBrand] = brand.toDictionary() // TODO: implement
        dict[kAPIKeyStatus] = status.rawValue as AnyObject?

        if let created = created {
            dict[kAPIKeyCreated] = (created as NSDate).formattedDate(withFormat: APIDefinitions.FullDateFormat) as AnyObject?
        }
        if let updated = updated {
            dict[kAPIKeyUpdated] = (updated as NSDate).formattedDate(withFormat: APIDefinitions.FullDateFormat) as AnyObject?
        }
        if let acceptedAt = acceptedAt {
            dict[kAPIKeyAcceptedAt] = (acceptedAt as NSDate).formattedDate(withFormat: APIDefinitions.FullDateFormat) as AnyObject?
        }
        
        return dict
    }
    
}
