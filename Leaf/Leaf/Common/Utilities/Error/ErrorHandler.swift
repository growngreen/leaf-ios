//
//  ErrorHandler.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 4.04.23.
//

import Foundation

protocol ErrorPresenting {
    func presentErrorAlert(with message: String)
}

protocol ErrorHandlerProtocol {
    func handle(_ error: Error)
}

class ErrorHandler: ErrorHandlerProtocol {

    private let errorPresenting: ErrorPresenting

    init(errorPresenting: ErrorPresenting) {
        self.errorPresenting = errorPresenting
    }

    func handle(_ error: Error) {

        let errorMessage: String

        if let error = error as? LocalizedError {
            errorMessage = error.errorDescription ?? R.string.localizable.general_error_title_description()
        } else {
            let nsError = error as NSError
            let nsErrorMessage = nsError.underlyingErrors.first?.localizedDescription
            errorMessage = nsErrorMessage ?? R.string.localizable.general_error_title_description()
        }

        errorPresenting.presentErrorAlert(with: errorMessage)
    }
}
