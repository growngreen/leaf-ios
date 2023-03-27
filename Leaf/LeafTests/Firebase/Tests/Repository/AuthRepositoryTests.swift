//
//  AuthRepositoryTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 17.02.23.
//

import Foundation
import XCTest
@testable import Leaf

final class AuthRepositoryTests: XCTestCase {

    func test_signUp_withNewEmail_shouldSignUpUser() async {
        // given
        let sut = makeSUT()

        // when
        try! await sut.signUp(email: "test@test.com", password: "test123")
        let user = sut.currentUser

        // then
        XCTAssertEqual(user?.email, "test@test.com")
    }

    func test_signUp_withExistingEmail_shouldThrowError() async {
        // given
        let sut = makeSUT(users: users)

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.signUp(email: user1.email, password: password1))
    }

    func test_signOut_withLoggedInUser_shouldlogOutCurrentuser() async {
        // given
        let sut = makeSUT()

        // when
        try! await sut.signUp(email: "test@test.com", password: "test123")
        try! await sut.signOut()

        // then
        XCTAssertNil(sut.currentUser)
    }

    func test_signOut_withoutLoggedInUser_shouldThrowError() async {
        // given
        let sut = makeSUT(users: users)

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.signOut())
    }

    func test_signIn_withExistingUserAndWrongPassword_shouldThrowError() async {
        // given
        let sut = makeSUT(users: users)

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.signIn(email: user1.email, password: "wrongPassword"))
    }

    func test_signIn_withExistingUserAndCorrectPassword_shouldSignInUser() async {
        // given
        let sut = makeSUT(users: users)

        // when
        try! await sut.signIn(email: user1.email, password: password1)
        let currentUser = sut.currentUser

        // then
        XCTAssertEqual(user1.id, currentUser?.id)
        XCTAssertEqual(user1.email, currentUser?.email)
    }

    func test_signIn_withoutExistingUser_shouldThrowError() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.signIn(email: user1.email, password: password1))
    }

    // MARK: - Helpers

    func makeSUT(users: [String: (user: UserDTO, password: String)] = [:]) -> AuthRepository {
        AuthRepository(dataSource: FirebaseAuthDataSourceMock(users: users))
    }

    var users: [String: (user: UserDTO, password: String)] {
        [
            user1.email: (user: user1, password: password1),
            user2.email: (user: user2, password: password2)
        ]
    }

    var user1: UserDTO {
        UserDTO(
            id: "0",
            email: "user1@test.com"
        )
    }

    var password1: String {
        "password1"
    }

    var user2: UserDTO {
        UserDTO(
            id: "1",
            email: "user2@test.com"
        )
    }

    var password2: String {
        "password2"
    }
}
