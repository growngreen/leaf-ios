//
//  AuthError.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 6.02.23.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidName
    case invalidEmail
    case invalidPassword
    case mismatchedPassword

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return R.string.localizable.auth_error_invalid_email()
        case .invalidPassword:
            return R.string.localizable.auth_error_invalid_password()
        case .invalidName:
            return R.string.localizable.auth_error_invalid_name()
        case .mismatchedPassword:
            return R.string.localizable.auth_error_mismatch_password()
        }
    }
}
