//
//  BaseCoordinator.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 29.05.23.
//

import Foundation
import UIKit
import Swinject

class BaseCoordinator {

    var childCoordinators = [BaseCoordinator]()
    let navigationController: UINavigationController
    let assembler: Assembler

    // for root
    init(navigationController: UINavigationController, assemblies: [Assembly] = []) {
        self.navigationController = navigationController
        self.assembler = Assembler(assemblies, parent: nil)
    }

    // for child
    init(parent: BaseCoordinator, assemblies: [Assembly] = []) {
        self.navigationController = parent.navigationController
        self.assembler = Assembler(assemblies, parent: parent.assembler)
    }

    func childDidFinish(_ child: BaseCoordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === child }) else { return }

        childCoordinators.remove(at: index)
    }
}
