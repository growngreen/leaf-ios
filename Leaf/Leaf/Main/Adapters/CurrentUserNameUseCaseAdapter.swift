//
//  CurrentUserNameUseCaseAdapter.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

class CurrentUserNameUseCaseAdapter: CurrentUserNameUseCaseProtocol {

    private let currentUserUseCase: GetCurrentUserUseCase

    init(currentUserUseCase: GetCurrentUserUseCase) {
        self.currentUserUseCase = currentUserUseCase
    }

    func execute() -> String? {
        let user = currentUserUseCase.execute()
        return user?.name
    }
}
