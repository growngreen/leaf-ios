//
//  ConfirmPasswordUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import Foundation

struct ConfirmPasswordUseCase {

    private let validatePasswordUseCase: ValidatePasswordUseCase

    init(validatePasswordUseCase: ValidatePasswordUseCase) {
        self.validatePasswordUseCase = validatePasswordUseCase
    }

    func execute(password: String, passwordConfirmation: String) throws {
        try validatePasswordUseCase.execute(password)
        try validatePasswordUseCase.execute(passwordConfirmation)

        guard password == passwordConfirmation else {
            throw AuthError.mismatchedPassword
        }
    }
}
