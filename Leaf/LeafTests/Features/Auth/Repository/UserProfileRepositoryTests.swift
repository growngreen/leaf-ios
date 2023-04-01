//
//  UserProfileRepositoryTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import XCTest
@testable import Leaf

final class UserProfileRepositoryTests: XCTestCase {

    func test_getCurrentProfile_withoutLoggedUser_shouldThrowError() {
        // given
        let sut = makeSUT()

        // when
        // then
        XCTAssertNil(sut.userProfile)
    }

    func test_getCurrentProfile_withLoggedUser_shouldReturnUserProfile() {
        // given
        let sut = makeSUT(currentProfile: userProfile)

        // when
        let profile = sut.userProfile

        // then
        XCTAssertNotNil(profile)
        XCTAssertEqual(profile?.id, userProfile.id)
        XCTAssertEqual(profile?.email, userProfile.email)
        XCTAssertEqual(profile?.image, userProfile.image)
        XCTAssertEqual(profile?.name, userProfile.name)
    }

    func test_updateProfile_withoutLoggedInUser_shouldThrowError() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.updateProfile(name: "newName", image: "newImage"))
    }

    func test_updateProfile_shouldReturnNewProfile() async {
        // given
        let sut = makeSUT(currentProfile: userProfile)

        // when
        let newProfile = try! await sut.updateProfile(name: "NewName", image: "NewImage")

        // then
        XCTAssertEqual(newProfile.id, userProfile.id)
        XCTAssertEqual(newProfile.email, userProfile.email)
        XCTAssertEqual(newProfile.image, "NewImage")
        XCTAssertEqual(newProfile.name, "NewName")
    }

    func test_updateProfile_shouldUpdateCurrentProfile() async {
        // given
        let sut = makeSUT(currentProfile: userProfile)

        // when
        _ = try! await sut.updateProfile(name: "NewName", image: "NewImage")
        let newProfile = sut.userProfile

        // then
        XCTAssertNotNil(newProfile)
        XCTAssertEqual(newProfile?.id, userProfile.id)
        XCTAssertEqual(newProfile?.email, userProfile.email)
        XCTAssertEqual(newProfile?.image, "NewImage")
        XCTAssertEqual(newProfile?.name, "NewName")
    }

    // MARK: - Helpers

    func makeSUT(currentProfile: UserProfileDTO? = nil) -> UserProfileRepository {
        UserProfileRepository(dataSource: UserProfileDataSourceMock(currentProfile: currentProfile))
    }

    var userProfile: UserProfileDTO {
        UserProfileDTO(
            id: "1",
            email: "user@test.com",
            name: "test",
            image: nil
        )
    }
}
