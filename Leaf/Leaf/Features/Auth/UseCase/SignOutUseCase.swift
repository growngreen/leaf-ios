//
//  SignOutUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

struct SignOutUseCase {

    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func execute() async throws {
        try await authRepository.signOut()
    }
}
