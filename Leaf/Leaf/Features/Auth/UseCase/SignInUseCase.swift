//
//  SignInUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

struct SignInUseCase {

    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) async throws {
        try await authRepository.signIn(email: email, password: password)
    }
}
