//
//  BaseViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

class BaseViewModel: ObservableObject {

    private let errorHandler: ErrorHandlerProtocol

    init(errorHandler: ErrorHandlerProtocol) {
        self.errorHandler = errorHandler
    }

    @MainActor
    func handle(_ error: Error) {
        errorHandler.handle(error)
    }
}
