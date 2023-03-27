//
//  AuthViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 16.03.23.
//

import Foundation

class AuthViewModel: ObservableObject {

    private weak var authCoordinating: AuthCoordinating?

    init(authCoordinating: AuthCoordinating) {
        self.authCoordinating = authCoordinating
    }

    func authenticate() {
        authCoordinating?.didAuthenticate()
    }
}
