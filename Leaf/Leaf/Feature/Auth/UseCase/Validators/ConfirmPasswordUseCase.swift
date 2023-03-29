//
//  ConfirmPasswordUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import Foundation

struct ConfirmPasswordUseCase {

    func execute(password: String, passwordConfirmation: String) -> Bool {
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard !passwordConfirmation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }

        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPasswordConfirmation = passwordConfirmation.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmedPassword.count > 6 else { return false }
        guard trimmedPasswordConfirmation.count > 6 else { return false }

        return trimmedPassword == trimmedPasswordConfirmation
    }
}
