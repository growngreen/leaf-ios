//
//  CoordinatorProtocol.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import UIKit
import Swinject

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController { get set }
    var assembler: Assembler { get set }

    func start()
}

extension CoordinatorProtocol {

    func childDidFinish(_ child: CoordinatorProtocol) {
        guard let childIndex = childCoordinators.firstIndex(where: { $0 === child }) else {
            return
        }

        childCoordinators.remove(at: childIndex)
    }
}
