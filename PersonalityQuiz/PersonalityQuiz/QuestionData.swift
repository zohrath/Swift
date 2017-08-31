//
//  QuestionData.swift
//  PersonalityQuiz
//
//  Created by Adam Woods on 2017-06-30.
//  Copyright © 2017 Adam Woods. All rights reserved.
//

import Foundation

struct Question {
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

enum ResponseType {
    case single, multiple, ranged
}

struct Answer {
    var text: String
    var type: AnimalType
}

enum AnimalType: Character {
    case dog = "🐶", cat = "🐱", rabbit = "🐰", turtle = "🐢"
    
    var definition: String {
        switch self {
        case .dog:
            return "You are a dog type"
        case .cat:
            return "You are a cat type"
        case .rabbit:
            return "You are a rabbit type"
        case .turtle:
            return "YOu are a turtle type"
        }
        
    }
}
