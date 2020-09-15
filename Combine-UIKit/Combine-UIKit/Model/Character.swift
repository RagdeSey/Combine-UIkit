//
//  Character.swift
//  Combine-UIKit
//
//  Created by Emilio Vásquez on 9/13/20.
//  Copyright © 2020 Emilio Vásquez. All rights reserved.
//

import Foundation

struct Character: Decodable, Hashable, Equatable {
    let charId: Int?
    let img: String?
    let name: String?
    let occupation: [String]?
    let portrayed: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case charId = "char_id"
        case img = "img"
        case name = "name"
        case occupation = "occupation"
        case portrayed = "portrayed"
        case status = "status"
    }

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.charId == rhs.charId
    }
}
