//
//  USStateCapital.swift
//  Proto File RW plus Firestore
//
//  Created by Santosh Krishnamurthy on 1/30/23.
//

import Foundation

struct State: Codable {
    let name: String
    let code: String
    let capital: String
    
    private enum CodingKeys: String, CodingKey  {
        case name = "state"
        case code = "abbreviation"
        case capital
    }
}

