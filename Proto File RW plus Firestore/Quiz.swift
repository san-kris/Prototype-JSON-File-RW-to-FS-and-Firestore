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
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "description": description,
            "difficulty": difficulty,
            "questions": questions.map({ question in
                question.dictionary
            })
        ]
    }
    
    private enum Codingkeys: String, CodingKey{
        case name
        case description
        case difficulty
        case questions
    }
}

extension Quiz: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
              let description = dictionary["name"] as? String,
              let difficulty = dictionary["difficulty"] as? Int,
              let questions = dictionary["questions"] as? [[String: Any]]
        else {return nil}
        let questionList = questions.compactMap({ item in
            Question(dictionary: item)
        })
        
        self.init(name: name,
                  description: description,
                  difficulty: difficulty,
                  questions: questionList
        )
        
    }
}

struct Question: Codable {
    let question: String
    let answer: String
    let options: [String]
    
    var dictionary: [String: Any] {
        return[
            "question": question,
            "answer": answer,
            "options": options
        ]
    }
    
    private enum Codingkeys: String, CodingKey{
        case question
        case answer
        case options
    }
}

extension Question: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let question = dictionary["question"] as? String,
              let answer = dictionary["answer"] as? String,
              let options = dictionary["options"] as? [String]
        else {return nil}
        
        self.init(question: question,
                  answer: answer,
                  options: options
        )
    }
}

