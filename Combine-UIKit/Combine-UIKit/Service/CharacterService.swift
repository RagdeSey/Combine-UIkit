//
//  CharacterService.swift
//  Combine-UIKit
//
//  Created by Emilio Vásquez on 9/13/20.
//  Copyright © 2020 Emilio Vásquez. All rights reserved.
//

import Foundation
import Combine

class CharacterService {
    let baseURL = "https://www.breakingbadapi.com/api/"

    enum CharacterEndpoints: String {
        case randomChars = "character/random"
    }

    // Method that fetch the characters from the API.
    func fetchCharacters(endpoint: CharacterEndpoints) -> AnyPublisher<[Character], Error> {
        let url = URL(string:  "\(baseURL)\(endpoint.rawValue)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Character].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
