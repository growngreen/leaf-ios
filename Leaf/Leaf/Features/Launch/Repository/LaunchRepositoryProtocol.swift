//
//  LaunchRepositoryProtocol.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation

protocol LaunchRepositoryProtocol {
    func isAuthenticated() async -> AuthState
}
