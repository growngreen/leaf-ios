//
//  MainCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI

protocol HomeCoordinating: AnyObject {
    func didSignedOut()
}

class MainCoordinator: BaseCoordinator {

    private weak var parentCoordinator: RootCoordinator?

    init(
        navigationController: UINavigationController,
        parentCoordinator: RootCoordinator
    ) {
        self.parentCoordinator = parentCoordinator

        super.init(parent: parentCoordinator)
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
        parentCoordinator?.coordinatorDidSignOut(self)
    }
}
