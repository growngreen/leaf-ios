//
//  ValidatePasswordUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 31.03.23.
//

import Foundation

struct ValidatePasswordUseCase {

    func execute(_ password: String) throws {
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AuthError.invalidPassword }
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedPassword.count > 6 else { throw AuthError.invalidPassword }
    }
}
