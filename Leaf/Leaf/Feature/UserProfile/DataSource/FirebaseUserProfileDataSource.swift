//
//  FirebaseUserProfileDataSource.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
import FirebaseAuth

class FirebaseUserProfileDataSource: UserProfileDataSourceProtocol {

    private let firebaseAuth: Auth

    var userProfile: UserProfileDTO? {
        try? userProfileDTO(from: firebaseAuth.currentUser)
    }

    init(firebaseAuth: Auth) {
        self.firebaseAuth = firebaseAuth
    }

    func updateProfile(name: String?, image: String?) async throws -> UserProfileDTO {
        let request = firebaseAuth.currentUser?.createProfileChangeRequest()

        if let name = name {
            request?.displayName = name
        }

        if let image = image {
            request?.photoURL = URL(string: image)
        }

        try await request?.commitChanges()

        return try userProfileDTO(from: firebaseAuth.currentUser)
    }
}

// MARK: - Helpers
private extension FirebaseUserProfileDataSource {
    func userProfileDTO(from firebaseUser: FirebaseAuth.User?) throws -> UserProfileDTO {

        guard let firebaseUser = firebaseUser else { throw UserProfileError.noUser }
        guard let name = firebaseUser.displayName else { throw UserProfileError.noName }
        guard let email = firebaseUser.email else { throw UserProfileError.noEmail }

        let image = firebaseUser.photoURL?.absoluteString

        return UserProfileDTO(
            id: firebaseUser.uid,
            email: email,
            name: name,
            image: image
        )
    }
}
