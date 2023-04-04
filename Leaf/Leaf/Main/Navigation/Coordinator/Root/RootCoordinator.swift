//
//  RootCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI
import Swinject

protocol LaunchCoordinating: AnyObject {
    func handleAuthState(_ authState: AuthState)
}

class RootCoordinator: CoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController
    var assembler: Assembler

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.assembler = Assembler([LaunchAssembly()], parent: nil)
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

    func coordinatorDidLogOut(_ coordinator: MainCoordinator) {
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
        let authCoordinator = AuthCoordinator(navigationController: navigationController, parent: self)
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }

    func showMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController, parent: self)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
}
