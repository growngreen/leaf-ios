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
        let view = AuthScreen(viewModel: assembler.resolver.resolve(AuthViewModel.self, argument: self as AuthCoordinating)!)
        let hostingController = UIHostingController(rootView: view)

        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - AuthCoordinating

extension AuthCoordinator: AuthCoordinating {

    func didAuthenticate() {
        parent?.coordinatorDidAuthenticate(self)
    }
}
