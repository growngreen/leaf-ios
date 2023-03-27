//
//  UserProfileDataSourceMock.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
@testable import Leaf

class UserProfileDataSourceMock: UserProfileDataSourceProtocol {

    enum UpdateUSerProfileError: Error {
        case noProfile
    }

    private var currentProfile: UserProfileDTO?

    var userProfile: Leaf.UserProfileDTO? {
        currentProfile
    }

    init(currentProfile: UserProfileDTO? = nil) {
        self.currentProfile = currentProfile
    }

    func updateProfile(name: String?, image: String?) async throws -> Leaf.UserProfileDTO {
        guard let currentProfile else { throw UpdateUSerProfileError.noProfile }

        let newProfile = UserProfileDTO(
            id: currentProfile.id,
            email: currentProfile.email,
            name: name ?? currentProfile.name,
            image: image ?? currentProfile.image
        )

        self.currentProfile = newProfile
        return newProfile
    }
}
