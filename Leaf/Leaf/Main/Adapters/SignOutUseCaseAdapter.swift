//
//  SignOutUseCaseAdapter.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

class SignOutUseCaseAdapter: SignOutUseCaseProtocol {

    private let signOutUseCase: SignOutUseCase

    init(signOutUseCase: SignOutUseCase) {
        self.signOutUseCase = signOutUseCase
    }

    func execute() async throws {
        try await signOutUseCase.execute()
    }
}
