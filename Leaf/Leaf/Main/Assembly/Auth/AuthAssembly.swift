//
//  AuthAssembly.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 16.03.23.
//

import Foundation
import Swinject
import FirebaseAuth

final class AuthAssembly: Assembly {

    func assemble(container: Container) {
        assembleDataSource(container)
        assembleRepository(container)
        assembleUseCase(container)
        assembleViewModel(container)
    }
}

// MARK: - DataSource

extension AuthAssembly {
    func assembleDataSource(_ container: Container) {
        container.register(Auth.self) { _ in
            Auth.auth()
        }
        .inObjectScope(.container)

        container.register(AuthDataSourceProtocol.self) { resolver in
            FirebaseAuthDataSource(firebaseAuth: resolver.resolve(Auth.self)!)
        }
        .inObjectScope(.container)
    }
}


// MARK: - Repository

extension AuthAssembly {
    func assembleRepository(_ container: Container) {
        container.register(AuthRepositoryProtocol.self) { resolver in
            AuthRepository(dataSource: resolver.resolve(AuthDataSourceProtocol.self)!)
        }
        .inObjectScope(.container)
    }
}

// MARK: - UseCase

extension AuthAssembly {
    func assembleUseCase(_ container: Container) {
        container.register(ValidateNameUseCase.self) { resolver in
            ValidateNameUseCase()
        }
        .inObjectScope(.transient)

        container.register(ValidatePasswordUseCase.self) { resolver in
            ValidatePasswordUseCase()
        }
        .inObjectScope(.transient)

        container.register(ValidateEmailUseCase.self) { resolver in
            ValidateEmailUseCase()
        }
        .inObjectScope(.transient)

        container.register(GetCurrentUserUseCase.self) { resolver in
            GetCurrentUserUseCase(authRepository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(SignOutUseCase.self) { resolver in
            SignOutUseCase(authRepository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(SignUpUseCase.self) { resolver in
            SignUpUseCase(
                authRepository: resolver.resolve(AuthRepositoryProtocol.self)!,
                validateNameUseCase: resolver.resolve(ValidateNameUseCase.self)!,
                validateEmailUseCase: resolver.resolve(ValidateEmailUseCase.self)!,
                confirmPasswordUseCase: resolver.resolve(ConfirmPasswordUseCase.self)!
            )
        }
        .inObjectScope(.transient)

        container.register(SignInUseCase.self) { resolver in
            SignInUseCase(authRepository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(ConfirmPasswordUseCase.self) { resolver in
            ConfirmPasswordUseCase(validatePasswordUseCase: resolver.resolve(ValidatePasswordUseCase.self)!)
        }
        .inObjectScope(.transient)
    }
}

// MARK: - ViewModel

extension AuthAssembly {
    func assembleViewModel(_ container: Container) {
        container.register(SignUpViewModel.self) { (resolver: Resolver, signUpCoordinating: SignUpCoordinating) in
            SignUpViewModel(
                signUpCoordinating: signUpCoordinating,
                signUpUseCase: resolver.resolve(SignUpUseCase.self)!
            )
        }
        .inObjectScope(.transient)

        container.register(SignInViewModel.self) { (resolver: Resolver, signInCoordinating: SignInCoordinating) in
            SignInViewModel(
                signInCoordinating: signInCoordinating,
                signInUseCase: resolver.resolve(SignInUseCase.self)!
            )
        }
    }
}
