//
//  UserProfileAssembly.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation
import Firebase
import Swinject

final class UserProfileAssembly: Assembly {

    func assemble(container: Container) {

        container.register(Auth.self) { _ in
            Auth.auth()
        }
        .inObjectScope(.container)

        container.register(UpdateUserProfileUseCase.self) { resolver in
            UpdateUserProfileUseCase(userProfileRepository: resolver.resolve(UserProfileRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(GetUserProfileUseCase.self) { resolver in
            GetUserProfileUseCase(userProfileRepository: resolver.resolve(UserProfileRepositoryProtocol.self)!)
        }
        .inObjectScope(.transient)

        container.register(UserProfileRepositoryProtocol.self) { resolver in
            UserProfileRepository(dataSource: resolver.resolve(UserProfileDataSourceProtocol.self)!)
        }
        .inObjectScope(.container)

        container.register(UserProfileDataSourceProtocol.self) { resolver in
            FirebaseUserProfileDataSource(firebaseAuth: resolver.resolve(Auth.self)!)
        }
        .inObjectScope(.container)
    }
}
