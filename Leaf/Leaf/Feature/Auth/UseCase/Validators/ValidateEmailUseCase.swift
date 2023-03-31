//
//  ValidateEmailUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import Foundation

struct ValidateEmailUseCase {

    func execute(_ email: String) throws {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthError.invalidEmail
        }

        let trimedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        guard emailPred.evaluate(with: trimedEmail) else {
            throw AuthError.invalidEmail
        }
    }
}
