//
//  GetCurrentUserUseCaseTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation
import XCTest
@testable import Leaf

final class GetCurrentUserUseCaseTests: XCTestCase {

    func test_getCurrentUser_withLoggedUser_shouldReturnCurrentUser() {
        // given
        let sut = makeSUT(users: users, loggedUser: user1)

        // when
        let user = sut.execute()

        // then
        XCTAssertNotNil(user)
        XCTAssertEqual(user1.id, user?.id)
        XCTAssertEqual(user1.email, user?.email)
    }

    func test_getCurrentUser_withoutLoggedUser_shouldReturnNil() {
        // given
        let sut = makeSUT(users: users)

        // when
        let user = sut.execute()

        // then
        XCTAssertNil(user)
    }

    // MARK: - Helpers

    func makeSUT(
        users: [String: (user: UserDTO, password: String)] = [:],
        loggedUser: UserDTO? = nil
    ) -> GetCurrentUserUseCase {
        GetCurrentUserUseCase(
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
            name: "0",
            email: "user1@test.com"
        )
    }

    var password1: String {
        "validPassword.123"
    }

    var user2: UserDTO {
        UserDTO(
            id: "1",
            name: "1",
            email: "user2@test.com"
        )
    }

    var password2: String {
        "validPassword.123"
    }
}
