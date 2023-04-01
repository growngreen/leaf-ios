//
//  BaseViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 1.04.23.
//

import Foundation

class BaseViewModel: ObservableObject {

    @MainActor
    @Published var hasError: Bool = false
    @MainActor
    @Published var error: LeafError? = nil

    private let errorHandler: any ErrorHandlerProtocol

    init(errorHandler: any ErrorHandlerProtocol) {
        self.errorHandler = errorHandler
    }

    func handle(_ error: Error) {
        Task {
            await MainActor.run(body: { [weak self] in
                self?.hasError = true
                self?.error = self?.errorHandler.localize(error)
            })
        }
    }
}
