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
        guard email.isValidEmail else { throw AuthError.invalidEmail }
        guard password.isValidPassword else { throw AuthError.invalidPassword }

        try await authRepository.signIn(email: email, password: password)
    }
}
