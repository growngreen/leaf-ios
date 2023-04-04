//
//  UpdateUserProfileUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

struct UpdateUserProfileUseCase {

    private let userProfileRepository: UserProfileRepositoryProtocol

    init(userProfileRepository: UserProfileRepositoryProtocol) {
        self.userProfileRepository = userProfileRepository
    }

    @discardableResult
    func execute(name: String?, image: String?) async throws -> UserProfile {

        if let name {
            guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw UserProfileError.invalidName
            }
        }

        if let image {
            guard !image.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  URL(string: image) != nil else {
                throw UserProfileError.invalidImage
            }
        }

        return try await userProfileRepository.updateProfile(
            name: name,
            image: image
        )
    }
}
