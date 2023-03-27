//
//  UpdateUserProfileUseCaseTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
import XCTest
@testable import Leaf

final class UpdateUserProfileUseCaseTests: XCTestCase {

    func test_updateProfile_withoutLoggedUser_shouldThrowError() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.execute(name: "newName", image: nil))
    }

    func test_updateProfile_withLoggedUserAndValidNameAndImage_shouldUpdateProfile() async {
        // given
        let sut = makeSUT(currentProfile: currentProfile)

        // when
        let newUserProfile = try! await sut.execute(name: "NewName", image: "https://picsum.photos/id/237/536/354")

        // then
        XCTAssertEqual(newUserProfile.name, "NewName")
        XCTAssertEqual(newUserProfile.image, "https://picsum.photos/id/237/536/354")
        XCTAssertEqual(newUserProfile.id, currentProfile.id)
        XCTAssertEqual(newUserProfile.email, currentProfile.email)
    }

    func test_updateProfile_withLoggedUserAndInvalidNameAndImage_shouldThrow() async {
        // given
        let sut = makeSUT(currentProfile: currentProfile)

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.execute(name: "", image: ""))
    }

    // MARK: - Helpers

    func makeSUT(currentProfile: UserProfileDTO? = nil) -> UpdateUserProfileUseCase {
        UpdateUserProfileUseCase(
            userProfileRepository: UserProfileRepository(
                dataSource: UserProfileDataSourceMock(
                    currentProfile: currentProfile
                )
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
