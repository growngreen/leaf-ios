//
//  AuthCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI
import Swinject

protocol SignInCoordinating: AnyObject {
    func didSignIn()
    func didRequestSignUp()
}

protocol SignUpCoordinating: AnyObject {
    func didSignUp()
    func didRequestSignIn()
}

class AuthCoordinator: CoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController
    var assembler: Assembler

    private weak var parent: RootCoordinator?

    init(navigationController: UINavigationController, parent: RootCoordinator?) {
        self.parent = parent
        self.navigationController = navigationController
        self.assembler = Assembler([AuthAssembly()], parent: parent?.assembler)
    }

    func start() {
        showSignIn()
    }
}

extension AuthCoordinator: SignUpCoordinating {

    func didSignUp() {
        parent?.coordinatorDidAuthenticate(self)
    }

    func didRequestSignIn() {
        showSignIn()
    }
}

extension AuthCoordinator: SignInCoordinating {

    func didSignIn() {
        parent?.coordinatorDidAuthenticate(self)
    }

    func didRequestSignUp() {
        showSignUp()
    }
}

private extension AuthCoordinator {

    func showSignIn() {
        let view = SignInScreen(viewModel: assembler.resolver.resolve(SignInViewModel.self, argument: self as SignInCoordinating)!)
        let hostingController = UIHostingController(rootView: view)

        navigationController.setViewControllers([hostingController], animated: false)
        hostingController.navigationController?.navigationBar.prefersLargeTitles = true
    }

    func showSignUp() {
        let view = SignUpScreen(viewModel: assembler.resolver.resolve(SignUpViewModel.self, argument: self as SignUpCoordinating)!)
        let hostingController = UIHostingController(rootView: view)

        navigationController.setViewControllers([hostingController], animated: false)
        hostingController.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
