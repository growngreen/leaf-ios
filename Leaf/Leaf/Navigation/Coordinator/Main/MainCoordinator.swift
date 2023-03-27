//
//  MainCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import SwiftUI
import Swinject

class MainCoordinator: CoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController
    var assembler: Assembler

    weak var parent: RootCoordinator?

    init(navigationController: UINavigationController, parent: RootCoordinator?) {
        self.parent = parent
        self.navigationController = navigationController
        self.assembler = Assembler([], parent: parent?.assembler)
    }

    func start() {
        let view = HomeScreen()
        let hostingController = UIHostingController(rootView: view)

        navigationController.setViewControllers([hostingController], animated: false)
    }
}
