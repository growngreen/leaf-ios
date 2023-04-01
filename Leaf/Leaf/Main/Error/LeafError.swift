//
//  LeafError.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 1.04.23.
//

import Foundation

enum LeafError: LocalizedError {
    case system(LocalizedError)
    case localized(LocalizedError)
    case `default`(Error)
    case general

    var errorDescription: String? {
        switch self {
        case .general:
            return R.string.localizable.general_error_title_description()
        case .system(let error):
            return error.errorDescription ?? LeafError.general.errorDescription
        case .localized(let error):
            return error.errorDescription ?? LeafError.general.errorDescription
        case .default(let error):
            let error = error as NSError
            return "\(R.string.localizable.general_error_title()) \(error.underlyingErrors.first?.localizedDescription ?? "")"
        }
    }
}

extension LeafError: Equatable {
    static func == (lhs: LeafError, rhs: LeafError) -> Bool {
        switch (lhs, rhs) {
        case (.general, .general):
            return true
        case (.default(let lhsType), .default(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.localized(let lhsType), .localized(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
