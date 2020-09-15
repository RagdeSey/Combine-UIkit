//
//  CharacterViewModel.swift
//  Combine-UIKit
//
//  Created by Emilio Vásquez on 9/13/20.
//  Copyright © 2020 Emilio Vásquez. All rights reserved.
//

import Foundation
import Combine

class CharacterViewModel {
    typealias ResultCharacters = Result<[Character], Error>

    let dependencies: CharacterService
    var breakingBadCharacters: [Character] = []

    init(dependencies: CharacterService = CharacterService()) {
        self.dependencies = dependencies
    }

    func fetchCharacter(input: AnyPublisher<Void, Never>) -> AnyPublisher<ResultCharacters, Never> {
        input.flatMap { _ in
            self.dependencies.fetchCharacters(endpoint: .randomChars)
                .map { ResultCharacters.success($0) }
                .catch { Just(.failure($0)) }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
