//
//  LaunchViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import Foundation

class LaunchViewModel: ObservableObject {

    @Published private(set) var showAnimation = false

    private let getAuthStateUseCase: GetAuthStateUseCase
    private weak var launchCoordinating: LaunchCoordinating?

    init(
        getAuthStateUseCase: GetAuthStateUseCase,
        launchCoordinating: LaunchCoordinating
    ) {
        self.getAuthStateUseCase = getAuthStateUseCase
        self.launchCoordinating = launchCoordinating
    }

    func checkAuthState() async {
        try? await Task.sleep(for: .seconds(0.5))

        let authState = await getAuthStateUseCase.execute()

        await MainActor.run { [weak self] in
            self?.showAnimation = true
        }

        try? await Task.sleep(for: .seconds(0.4))

        await MainActor.run { [weak self] in
            self?.launchCoordinating?.handleAuthState(authState)
        }
    }
}
