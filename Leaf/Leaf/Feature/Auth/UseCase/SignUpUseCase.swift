//
//  SignUpUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

struct SignUpUseCase {

    private let authRepository: AuthRepositoryProtocol

    private let validateNameUseCase: ValidateNameUseCase
    private let validateEmailUseCase: ValidateEmailUseCase
    private let confirmPasswordUseCase: ConfirmPasswordUseCase

    init(
        authRepository: AuthRepositoryProtocol,
        validateNameUseCase: ValidateNameUseCase,
        validateEmailUseCase: ValidateEmailUseCase,
        confirmPasswordUseCase: ConfirmPasswordUseCase
    ) {
        self.authRepository = authRepository
        self.validateNameUseCase = validateNameUseCase
        self.validateEmailUseCase = validateEmailUseCase
        self.confirmPasswordUseCase = confirmPasswordUseCase
    }

    func execute(name: String, email: String, password: String, confirmPassword: String) async throws {
        try validateNameUseCase.execute(name)
        try validateEmailUseCase.execute(email)
        try confirmPasswordUseCase.execute(password: password, passwordConfirmation: confirmPassword)

        try await authRepository.signUp(name: name, email: email, password: password)
    }
}
