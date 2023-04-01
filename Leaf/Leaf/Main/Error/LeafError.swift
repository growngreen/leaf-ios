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
