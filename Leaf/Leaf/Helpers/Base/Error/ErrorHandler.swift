//
//  AuthErrorHandler.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 1.04.23.
//

import Foundation

protocol ErrorHandlerProtocol {
    func localize(_ error: Error) -> LeafError
}

class ErrorHandler<T: LocalizedError>: ErrorHandlerProtocol {

    func localize(_ error: Error) -> LeafError {

        if let error = error as? T {
            return .system(error)
        } else if let error = error as? LocalizedError {
            return .localized(error)
        } else {
            return .default(error)
        }
    }
}
