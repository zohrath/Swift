//
//  User.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 06/03/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation
import DateTools

private let kAPIKeyId = "id"
private let kAPIKeyEmail = "email"
private let kAPIKeyFirstName = "first_name"
private let kAPIKeyLastName = "last_name"
private let kAPIKeyGender = "gender"
private let kAPIKeyBirthDate = "birth_date"
private let kAPIKeyCreated = "created"
private let kAPIKeyProfileImage = "profile_image"
private let kAPIKeyProfileBackgroundImage = "profile_background"
private let kAPIKeyOver21 = "over_21"
private let kAPIKeyShowWallet = "show_wallet_to_others"
private let kAPIKeyShowChannels = "show_channels_to_others"
private let kAPIKeySearchable = "searchable"

open class User {
    
    var id: Int = 0
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var gender: Gender?
    var profileImage: String?
    var profileBackgroundImage: String?
    
    var birthDate: Date?
    var created: Date?
    
    var hasProfilePicture: Bool {
        get {
            return profileImage != nil
        }
    }
    
    var show_wallet_to_others: Bool?
    var show_channels_to_others: Bool?
    var over_21: Bool?
    var searchable: Bool?
    
    init(dictionary: [String:Any]) {
        if let search = dictionary[kAPIKeySearchable] as? Bool {
            self.searchable = search
        }
        if let over = dictionary[kAPIKeyOver21] as? Bool {
            self.over_21 = over
        }
        if let showWallet = dictionary[kAPIKeyShowWallet] as? Bool {
            self.show_wallet_to_others = showWallet
        }
        if let showChannels = dictionary[kAPIKeyShowChannels] as? Bool {
            self.show_channels_to_others = showChannels
        }
        if let id = dictionary[kAPIKeyId] as? Int {
            self.id = id
        }
        if let email = dictionary[kAPIKeyEmail] as? String {
            self.email = email
        }
        if let firstName = dictionary[kAPIKeyFirstName] as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary[kAPIKeyLastName] as? String {
            self.lastName = lastName
        }
        if let genderString = dictionary[kAPIKeyGender] as? String, let gender = Gender(rawValue: genderString) {
            self.gender = gender
        }
        if let profileImage = dictionary[kAPIKeyProfileImage] as? String {
            self.profileImage = profileImage
        }
        if let profileBackgroundImage = dictionary[kAPIKeyProfileBackgroundImage] as? String {
            self.profileBackgroundImage = profileBackgroundImage
        }
        if let birthDate = dictionary[kAPIKeyBirthDate] as? String {
            self.birthDate = NSDate(string: birthDate, formatString: APIDefinitions.FullDateFormat) as Date?
        }
        if let created = dictionary[kAPIKeyCreated] as? String {
            self.created = NSDate(string: created, formatString: APIDefinitions.FullDateFormat) as Date?
        }
    }
    func setProfilePicture(_ imageUrl:String) {
        self.profileImage = imageUrl
    }
    func setBackgroundPhoto(_ imageUrl:String) {
        self.profileBackgroundImage = imageUrl
    }
    /**
     Converts user to dictionary. Only include what can be updated in the back-end API.
     */
    func toDictionary() -> [String:Any] {
        var dict: [String: AnyObject] = [:]
        dict[kAPIKeyId] = id as AnyObject?
        dict[kAPIKeyEmail] = email as AnyObject?
        dict[kAPIKeyFirstName] = firstName as AnyObject?
        dict[kAPIKeyLastName] = lastName as AnyObject?
        dict[kAPIKeyOver21] = over_21 as AnyObject?
        dict[kAPIKeyShowWallet] = show_wallet_to_others as AnyObject?
        dict[kAPIKeyShowChannels] = show_channels_to_others as AnyObject?
        dict[kAPIKeySearchable] = searchable as AnyObject?
        
        if let gender = gender {
            dict[kAPIKeyGender] = gender.rawValue as AnyObject?
        }
        if let birthDate = birthDate {
            dict[kAPIKeyBirthDate] = (birthDate as NSDate).formattedDate(withFormat: APIDefinitions.FullDateFormat) as AnyObject?
        }
        return dict
    }
    
}

/*
 {
	"id": 1,
	"is_superuser": true,
	"created": "2016-03-21 15:25:26 UTC+0000",
	"updated": "2016-04-12 09:45:11 UTC+0000",
	"email": "simon@ilistambassador.com",
	"is_staff": true,
	"is_active": true,
	"first_name": "",
	"last_name": "",
	"gender": null,
	"birth_date": null,
	"allow_crossover": true,
	"profile_image": "https://ilistambassador.s3.amazonaws.com:443/user/profile_images/IMG_2176.JPG",
	"profile_background": "https://ilistambassador.s3.amazonaws.com:443/user/profile_backgrounds/iPhone_Image_2456A6.jpg"
 }
 */
