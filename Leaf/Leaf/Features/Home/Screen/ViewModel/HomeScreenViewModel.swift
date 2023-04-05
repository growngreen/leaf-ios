//
//  HomeScreenViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

protocol CurrentUserNameUseCaseProtocol {
    func execute() -> String?
}

class HomeScreenViewModel: BaseViewModel {

    private let currentUserNameUseCase: CurrentUserNameUseCaseProtocol
    private let userGreetingUseCase: UserGreetingUseCase

    init(
        errorHandler: ErrorHandlerProtocol,
        userGreetingUseCase: UserGreetingUseCase,
        currentUserNameUseCase: CurrentUserNameUseCaseProtocol
    ) {
        self.userGreetingUseCase = userGreetingUseCase
        self.currentUserNameUseCase = currentUserNameUseCase

        super.init(errorHandler: errorHandler)
    }

    var title: String {
        let userName = currentUserNameUseCase.execute()
        return userGreetingUseCase.execute(with: userName)
    }

    func tapOptionsButton() {

    }
}
