//
//  CommonAssembly.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation
import Swinject

class CommonAssembly: Assembly {

    func assemble(container: Container) {

        container.register(AlertPresenterProtocol.self) { resolver in
            AlertPresenter()
        }
        .inObjectScope(.container)

        container.register(ErrorHandlerProtocol.self) { resolver in
            ErrorHandler(errorPresenting: resolver.resolve(AlertPresenterProtocol.self)! as! ErrorPresenting)
        }
        .inObjectScope(.container)
    }
}
