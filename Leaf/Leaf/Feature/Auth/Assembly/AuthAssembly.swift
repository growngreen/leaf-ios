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
            SignUpUseCase(authRepository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(SignInUseCase.self) { resolver in
            SignInUseCase(authRepository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(AuthViewModel.self) { (resolver: Resolver, authCoordinating: AuthCoordinating) in
            AuthViewModel(authCoordinating: authCoordinating)
        }
        .inObjectScope(.transient)
    }
}
