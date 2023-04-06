//
//  BaseViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

class BaseViewModel: ObservableObject {

    private let errorHandler: ErrorHandlerProtocol

    let alertPresenter: AlertPresenterProtocol

    init(
        errorHandler: ErrorHandlerProtocol,
        alertPresenter: AlertPresenterProtocol
    ) {
        self.errorHandler = errorHandler
        self.alertPresenter = alertPresenter
    }

    @MainActor
    func handle(_ error: Error) {
        errorHandler.handle(error)
    }
}
