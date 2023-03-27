//
//  SignOutUseCaseTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
import XCTest
@testable import Leaf

final class SignOutUseCaseTests: XCTestCase {

    func test_signOut_withoutLoggedUser_shouldThrowError() async {
        // given
        let sut = makeSUT()

        // when
        // then
        await XCTAssertThrowsErrorAsync(try await sut.execute())
    }

    func test_signOut_withLoggedUser_shouldSignOut() async {
        // given
        let sut = makeSUT(users: users, loggedUser: user1)

        // when
        // then
        await XCTAssertNoThrowsAsync(try await sut.execute())
    }

    // MARK: - Helpers

    func makeSUT(
        users: [String: (user: UserDTO, password: String)] = [:],
        loggedUser: UserDTO? = nil
    ) -> SignOutUseCase {
        SignOutUseCase(
            authRepository:
                AuthRepository(
                    dataSource:
                        FirebaseAuthDataSourceMock(
                            users: users,
                            loggedUser: loggedUser
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
