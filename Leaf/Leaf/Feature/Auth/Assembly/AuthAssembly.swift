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

        container.register(Auth.self) { _ in
            Auth.auth()
        }
        .inObjectScope(.container)

        container.register(AuthDataSourceProtocol.self) { resolver in
            FirebaseAuthDataSource(firebaseAuth: resolver.resolve(Auth.self)!)
        }
        .inObjectScope(.container)

        container.register(AuthRepositoryProtocol.self) { resolver in
            AuthRepository(dataSource: resolver.resolve(AuthDataSourceProtocol.self)!)
        }
        .inObjectScope(.container)

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

        container.register(ValidateEmailUseCase.self) { resolver in
            ValidateEmailUseCase()
        }
        .inObjectScope(.transient)

        container.register(ValidatePasswordUseCase.self) { resolver in
            ValidatePasswordUseCase()
        }
        .inObjectScope(.transient)

        container.register(ValidateNameUseCase.self) { resolver in
            ValidateNameUseCase()
        }
        .inObjectScope(.transient)

        container.register(SignUpViewModel.self) { (resolver: Resolver, authCoordinating: AuthCoordinating) in
            SignUpViewModel(
                authCoordinating: authCoordinating,
                signUpUseCase: resolver.resolve(SignUpUseCase.self)!
            )
        }
        .inObjectScope(.transient)
    }
}
