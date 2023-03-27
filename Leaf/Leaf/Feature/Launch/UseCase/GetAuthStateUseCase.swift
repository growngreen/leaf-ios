//
//  GetAuthStateUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation

class GetAuthStateUseCase {

    private let launchRepository: LaunchRepositoryProtocol

    init(launchRepository: LaunchRepositoryProtocol) {
        self.launchRepository = launchRepository
    }

    func execute() async -> AuthState {
        await launchRepository.isAuthenticated()
    }
}
