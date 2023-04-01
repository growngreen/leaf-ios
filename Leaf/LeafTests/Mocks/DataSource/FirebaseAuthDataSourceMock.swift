//
//  FirebaseAuthDataSourceMock.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 17.02.23.
//

import Foundation
@testable import Leaf

final class FirebaseAuthDataSourceMock: AuthDataSourceProtocol {

    enum AuthError: Error {
        case noUser
    }

    private var users: [String: (user: UserDTO, password: String)]
    private var loggedUser: UserDTO?

    var currentUser: UserDTO? {
        loggedUser
    }

    init(
        users: [String: (user: UserDTO, password: String)] = [:],
        loggedUser: UserDTO? = nil
    ) {
        self.loggedUser = loggedUser
        self.users = users
    }

    func signUp(name: String, email: String, password: String) async throws {
        guard !users.contains(where: { (key, value) in
            key == email
        }) else { throw AuthError.noUser }

        let user = UserDTO(
            id: UUID().uuidString,
            name: name,
            email: email
        )

        users[user.email] = (user, password)
        loggedUser = user
    }

    func signIn(email: String, password: String) async throws {
        guard let user = users.first(where: { (key, tuple) in
            key == email && tuple.password == password
        }) else { throw AuthError.noUser }

        loggedUser = user.value.user
    }

    func signOut() async throws {
        guard loggedUser != nil else { throw AuthError.noUser }
        loggedUser = nil
    }
}
