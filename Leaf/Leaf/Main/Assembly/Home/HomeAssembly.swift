//
//  HomeAssembly.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation
import Swinject

class HomeAssembly: Assembly {

    func assemble(container: Container) {

        container.register(CurrentUserNameUseCaseProtocol.self) { resolver in
            CurrentUserNameUseCaseAdapter(currentUserUseCase: resolver.resolve(GetCurrentUserUseCase.self)!)
        }
        .inObjectScope(.transient)

        container.register(UserGreetingUseCase.self) { resolver in
            UserGreetingUseCase()
        }
        .inObjectScope(.transient)

        container.register(HomeScreenViewModel.self) { resolver in
            HomeScreenViewModel(
                errorHandler: resolver.resolve(ErrorHandlerProtocol.self)!,
                userGreetingUseCase: resolver.resolve(UserGreetingUseCase.self)!,
                currentUserNameUseCase: resolver.resolve(CurrentUserNameUseCaseProtocol.self)!
            )
        }
        .inObjectScope(.transient)
    }
}
