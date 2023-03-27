//
//  GetUserProfileUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

struct GetUserProfileUseCase {

    private let userProfileRepository: UserProfileRepositoryProtocol

    init(userProfileRepository: UserProfileRepositoryProtocol) {
        self.userProfileRepository = userProfileRepository
    }

    func execute() -> UserProfile? {
        userProfileRepository.userProfile
    }
}
