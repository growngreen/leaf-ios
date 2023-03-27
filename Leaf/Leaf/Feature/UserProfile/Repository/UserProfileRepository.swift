//
//  UserProfileRepository.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

class UserProfileRepository: UserProfileRepositoryProtocol {

    private let dataSource: UserProfileDataSourceProtocol

    var userProfile: UserProfile? {
        guard let userProfile = dataSource.userProfile else { return nil }

        return leafUserProfile(from: userProfile)
    }

    init(dataSource: UserProfileDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func updateProfile(name: String?, image: String?) async throws -> UserProfile {
        let newProfile = try await dataSource.updateProfile(name: name, image: image)

        return leafUserProfile(from: newProfile)
    }
}

// MARK: - Helpers

private extension UserProfileRepository {
    func leafUserProfile(from dto: UserProfileDTO) -> UserProfile {
        UserProfile(
            id: dto.id,
            email: dto.email,
            name: dto.name,
            image: dto.image
        )
    }
}
