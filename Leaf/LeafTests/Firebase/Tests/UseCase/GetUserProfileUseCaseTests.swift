//
//  GetUserProfileUseCaseTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
import XCTest
@testable import Leaf

final class GetUserProfileUseCaseTests: XCTestCase {

    func test_getUserProfile_withoutLoggedUser_shouldReturnNil() {
        // given
        let sut = makeSUT()

        // when
        let userProfile = sut.execute()

        // then
        XCTAssertNil(userProfile)
    }

    func test_getUserProfile_withLoggedUser_sholdReturnUserProfile() {
        // given
        let sut = makeSUT(currentProfile: currentProfile)

        // when
        let userProfile = sut.execute()

        // then
        XCTAssertEqual(userProfile?.email, currentProfile.email)
        XCTAssertEqual(userProfile?.id, currentProfile.id)
        XCTAssertEqual(userProfile?.name, currentProfile.name)
        XCTAssertEqual(userProfile?.image, currentProfile.image)
    }

    // MARK: - Helpers

    func makeSUT(currentProfile: UserProfileDTO? = nil) -> GetUserProfileUseCase {
        GetUserProfileUseCase(
            userProfileRepository: UserProfileRepository(
                dataSource: UserProfileDataSourceMock(currentProfile: currentProfile)
            )
        )
    }

    var currentProfile: UserProfileDTO {
        UserProfileDTO(
            id: "1",
            email: "test@gmail.com",
            name: "Test",
            image: nil
        )
    }
}
