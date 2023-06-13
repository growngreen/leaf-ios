//
//  RootCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI

protocol LaunchCoordinating: AnyObject {
    func handleAuthState(_ authState: AuthState)
}

class RootCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController) {
        super.init(
            navigationController: navigationController,
            assemblies: [
                CommonAssembly(),
                LaunchAssembly(),
                AuthAssembly(),
                HomeAssembly(),
                UserProfileAssembly()
            ]
        )
    }

    func start() {
        let viewModel = assembler.resolver.resolve(LaunchViewModel.self, argument: self as LaunchCoordinating)!
        let launchScreen = LaunchScreen(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: launchScreen)

        navigationController.setViewControllers([hostingController], animated: true)
    }

    func coordinatorDidAuthenticate(_ coordinator: AuthCoordinator) {
        childDidFinish(coordinator)
        showMain()
    }

    func coordinatorDidSignOut(_ coordinator: MainCoordinator) {
        childDidFinish(coordinator)
        showAuth()
    }
}

extension RootCoordinator: LaunchCoordinating {

    func handleAuthState(_ authState: AuthState) {
        switch authState {
        case .authenticated:
            showMain()
        case .unautheticated:
            showAuth()
        }
    }
}

private extension RootCoordinator {

    func showAuth() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }

    func showMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
