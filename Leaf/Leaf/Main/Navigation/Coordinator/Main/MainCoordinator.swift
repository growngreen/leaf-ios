//
//  MainCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI
import Swinject

protocol HomeCoordinating: AnyObject {
    func didSignedOut()
}

class MainCoordinator: CoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController
    var assembler: Assembler

    weak var parent: RootCoordinator?

    init(navigationController: UINavigationController, parent: RootCoordinator?) {
        self.parent = parent
        self.navigationController = navigationController
        self.assembler = Assembler([HomeAssembly(), AuthAssembly()], parent: parent?.assembler)
    }

    func start() {
        let viewModel = assembler.resolver.resolve(HomeScreenViewModel.self, argument: self as HomeCoordinating)!
        let view = HomeScreen(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)

        navigationController.setViewControllers([hostingController], animated: false)
        hostingController.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MainCoordinator: HomeCoordinating {

    func didSignedOut() {
        parent?.coordinatorDidSignOut(self)
    }
}
