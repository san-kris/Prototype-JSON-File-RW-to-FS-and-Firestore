//
//  Quiz.swift
//  Proto File RW plus Firestore
//
//  Created by Santosh Krishnamurthy on 2/11/23.
//

import Foundation

struct Quiz: Codable {
    let name: String
    let description: String
    let difficulty: Int
    let questions: [Question]
    
    private enum Codingkeys: String, CodingKey{
        case name
        case description
        case difficulty
        case questions
    }
}

struct Question: Codable {
    let question: String
    let answer: String
    let options: [String]
    
    private enum Codingkeys: String, CodingKey{
        case question
        case answer
        case options
    }
}
