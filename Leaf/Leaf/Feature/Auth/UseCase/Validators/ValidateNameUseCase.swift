//
//  ValidateNameUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 31.03.23.
//

import Foundation

struct ValidateNameUseCase {

    func execute(_ name: String) throws {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AuthError.invalidName }
    }
}
