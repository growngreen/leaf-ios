//
//  LaunchAssembly.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 16.03.23.
//

import Foundation
import Swinject
import FirebaseAuth

final class LaunchAssembly: Assembly {

    func assemble(container: Container) {

        container.register(Auth.self) { _ in
            Auth.auth()
        }
        .inObjectScope(.container)

        container.register(LaunchDataSourceProtocol.self) { resolver in
            FirebaseLaunchDataSource(auth: resolver.resolve(Auth.self)!)
        }
        .inObjectScope(.container)

        container.register(LaunchRepositoryProtocol.self) { resolver in
            LaunchRepository(dataSource: resolver.resolve(LaunchDataSourceProtocol.self)!)
        }
        .inObjectScope(.container)

        container.register(GetAuthStateUseCase.self) { resolver in
            GetAuthStateUseCase(launchRepository: resolver.resolve(LaunchRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(LaunchViewModel.self) { (resolver: Resolver, launchCoordinating: LaunchCoordinating) in
            LaunchViewModel(getAuthStateUseCase: resolver.resolve(GetAuthStateUseCase.self)!, launchCoordinating: launchCoordinating)
        }
        .inObjectScope(.transient)
    }
}
