//
//  AuthCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI

protocol SignInCoordinating: AnyObject {
    func didSignIn()
    func didRequestSignUp()
}

protocol SignUpCoordinating: AnyObject {
    func didSignUp()
    func didRequestSignIn()
}

class AuthCoordinator: BaseCoordinator {

    private weak var parentCoordinator: RootCoordinator?

    init(
        navigationController: UINavigationController,
        parentCoordinator: RootCoordinator
    ) {
        self.parentCoordinator = parentCoordinator

        super.init(parent: parentCoordinator)
    }

    func start() {
        showSignIn()
    }
}

extension AuthCoordinator: SignUpCoordinating {

    func didSignUp() {
        parentCoordinator?.coordinatorDidAuthenticate(self)
    }

    func didRequestSignIn() {
        showSignIn()
    }
}

extension AuthCoordinator: SignInCoordinating {

    func didSignIn() {
        parentCoordinator?.coordinatorDidAuthenticate(self)
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
