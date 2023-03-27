//
//  FirebaseAuthDataSource.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 6.02.23.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthDataSource: AuthDataSourceProtocol {

    private let firebaseAuth: Auth

    var currentUser: UserDTO? {
        userDto(from: firebaseAuth.currentUser)
    }

    init(firebaseAuth: Auth) {
        self.firebaseAuth = firebaseAuth
    }

    func signUp(email: String, password: String) async throws {
        try await firebaseAuth.createUser(withEmail: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        try await firebaseAuth.signIn(withEmail: email, password: password)
    }

    func signOut() async throws {
        try firebaseAuth.signOut()
    }
}

// MARK: - Helpers

private extension FirebaseAuthDataSource {
    func userDto(from firebaseUser: FirebaseAuth.User?) -> UserDTO? {
        guard let userId = firebaseUser?.uid else { return nil }
        guard let userEmail = firebaseUser?.email else { return nil }

        return UserDTO(
            id: userId,
            email: userEmail
        )
    }
}
