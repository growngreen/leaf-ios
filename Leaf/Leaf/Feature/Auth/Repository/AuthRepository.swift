//
//  AuthRepository.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 17.02.23.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {

    private let dataSource: AuthDataSourceProtocol

    var currentUser: User? {
        leafUser(from: dataSource.currentUser)
    }

    init(dataSource: AuthDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func signUp(email: String, password: String) async throws {
        try await dataSource.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        try await dataSource.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await dataSource.signOut()
    }
}

// MARK: - Helpers

private extension AuthRepository {
    func leafUser(from dto: UserDTO?) -> User? {
        guard let dto else { return nil }

        return User(
            id: dto.id,
            email: dto.email
        )
    }
}
