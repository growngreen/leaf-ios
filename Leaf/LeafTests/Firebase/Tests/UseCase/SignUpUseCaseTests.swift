//
//  SignUpUseCaseTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
import XCTest
@testable import Leaf

final class SignUpUseCaseTests: XCTestCase {

    func test_signUp_withInvalidEmail_shouldThrowError() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.execute(email: "t", password: "validPassword.123"))
    }

    func test_signUp_withInvalidPassword_shouldThrowError() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.execute(email: "test@gmail.com", password: "1"))
    }

    func test_signUp_withValidCredentialsAndExistingEmail_shouldThrowError() async {
        // given
        let sut = makeSUT(users: users)

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.execute(email: "user1@test.com", password: "validPassword.123"))
    }

    func test_signUp_withValidCredentials_shouldSignUp() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertNoThrowsAsync(try await sut.execute(email: "test@gmail.com", password: "validPassword.123"))
    }

    // MARK: - Helpers

    func makeSUT(users: [String: (user: UserDTO, password: String)] = [:]) -> SignUpUseCase {
        SignUpUseCase(
            authRepository: AuthRepository(
                dataSource: FirebaseAuthDataSourceMock(
                    users: users
                )
            )
        )
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
        "validPassword.123"
    }

    var user2: UserDTO {
        UserDTO(
            id: "1",
            email: "user2@test.com"
        )
    }

    var password2: String {
        "validPassword.123"
    }
}
