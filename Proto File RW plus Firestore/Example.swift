//
//  Example.swift
//  Proto File RW plus Firestore
//
//  Created by Santosh Krishnamurthy on 1/30/23.
//

import Foundation

struct Example: Codable {
    let name: String
    let count: Int
    
    private enum CodingKeys: String, CodingKey{
        case name = "bar"
        case count = "baz"
    }
}
