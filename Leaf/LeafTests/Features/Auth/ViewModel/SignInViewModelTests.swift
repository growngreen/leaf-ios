//
//  SignInViewModelTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 1.04.23.
//

import Foundation
import XCTest
import Combine
@testable import Leaf

final class SignInViewModelTests: XCTestCase {

    private var didSignInCount = 0
    private var didRequestSignUpCount = 0

    private var cancellables = Set<AnyCancellable>()

    func test_didRequestSignUp_shouldRequestSignUpScreen() {
        // given
        let sut = makeSUT()

        // when
        sut.didTapSignUp()

        // then
        XCTAssertEqual(didRequestSignUpCount, 1)
    }

    func test_notFillingAllFields_shouldNotEnableSubmitButtonAfterDebounce() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Submit button is disabled")

        // when
        sut.$isSubmitButtonDisabled
            .dropFirst()
            .sink { isDisabled in
                XCTAssertTrue(isDisabled)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.email = "something"

        // then
        wait(for: [expectation], timeout: 1)
    }

    func test_fillingAllFields_shouldEnableSubmitButtonAfterDebounce() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Submit button is enabled")

        // when
        sut.$isSubmitButtonDisabled
            .dropFirst()
            .sink { isDisabled in
                XCTAssertFalse(isDisabled)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.email = "something"
        sut.password = "password"

        // then
        wait(for: [expectation], timeout: 1)
    }

    func test_submitOnEmailField_shouldChangeFocusToPassword() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Change focus to password")

        sut.$focusedField
            .dropFirst()
            .sink { field in
                XCTAssertEqual(field, .password)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.submit(.email)

        // then
       wait(for: [expectation], timeout: 1)
    }

    func test_submitOnPasswordField_withoutFormInput_shouldResignFocus() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Resign focus")

        sut.$focusedField
            .dropFirst()
            .sink { field in
                XCTAssertNil(field)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.submit(.password)

        // then
       wait(for: [expectation], timeout: 1)
    }

    func test_submitOnPasswordField_withValidFormInput_shouldSignInAndRequestNavigation() async {
        // given
        let sut = makeSUT(users: users)

        // when
        sut.email = user1.email
        sut.password = password1
        sut.submit(.password)

        try? await Task.sleep(for: .seconds(1))

        // then
        XCTAssertEqual(didSignInCount, 1)
    }

    func test_submitButton_withValidFormInput_shouldSignInAndRequestNavigation() async {
        // given
        let sut = makeSUT(users: users)

        // when
        sut.email = user1.email
        sut.password = password1
        sut.signIn()

        try? await Task.sleep(for: .seconds(1))

        // then
        XCTAssertEqual(didSignInCount, 1)
    }

    // MARK: - Helpers

    func makeSUT(users: [String : (user: UserDTO, password: String)] = [:]) -> SignInViewModel {
        SignInViewModel(
            errorHandler: ErrorHandler<AuthError>(),
            signInCoordinating: self,
            signInUseCase: SignInUseCase(
                authRepository: AuthRepository(
                    dataSource: FirebaseAuthDataSourceMock(
                        users: users
                    )
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

// MARK: - SignInCoordinating

extension SignInViewModelTests: SignInCoordinating {
    func didSignIn() {
        didSignInCount += 1
    }

    func didRequestSignUp() {
        didRequestSignUpCount += 1
    }
}
