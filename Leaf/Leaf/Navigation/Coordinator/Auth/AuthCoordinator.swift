//
//  AuthCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI
import Swinject

protocol AuthCoordinating: AnyObject {
    func didAuthenticate()
    func didRequestSignIn()
}

class AuthCoordinator: CoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController
    var assembler: Assembler

    weak var parent: RootCoordinator?

    init(navigationController: UINavigationController, parent: RootCoordinator?) {
        self.parent = parent
        self.navigationController = navigationController
        self.assembler = Assembler([AuthAssembly()], parent: parent?.assembler)
    }

    func start() {
        let view = SignUpScreen(viewModel: assembler.resolver.resolve(SignUpViewModel.self, argument: self as AuthCoordinating)!)
        let hostingController = UIHostingController(rootView: view)

        navigationController.setViewControllers([hostingController], animated: false)
        hostingController.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension AuthCoordinator: AuthCoordinating {

    func didAuthenticate() {
        parent?.coordinatorDidAuthenticate(self)
    }

    func didRequestSignIn() {
        showSignIn()
    }
}

private extension AuthCoordinator {

    func showSignIn() {
        let view = SignInScreen()
        let hostingController = UIHostingController(rootView: view)

        navigationController.pushViewController(hostingController, animated: true)
    }
}
