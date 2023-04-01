//
//  SignUpViewModelTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 31.03.23.
//

import Foundation
import XCTest
import Combine
@testable import Leaf

final class SignUpViewModelTests: XCTestCase {

    private var didAuthenticateCount = 0
    private var didRequestSignInCount = 0

    private var cancellables = Set<AnyCancellable>()

    func test_notFillingAllFields_shouldNotEnableSubmitButtonAfterDebounce() {

        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Submit button is disabled")

        sut.$isSubmitButtonDisabled
            .dropFirst()
            .sink { isDisabled in
                XCTAssertTrue(isDisabled)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.email = "something"
        sut.password = "password"
        sut.confirmPassword = "password"

        wait(for: [expectation], timeout: 1)
    }

    func test_fillingAllFields_shouldEnableSubmitButtonAfterDebounce() {

        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Submit button is enabled")

        sut.$isSubmitButtonDisabled
            .dropFirst()
            .sink { isDisabled in
                XCTAssertFalse(isDisabled)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.name = "test"
        sut.email = "something"
        sut.password = "password"
        sut.confirmPassword = "password"

        wait(for: [expectation], timeout: 1)
    }

    func test_didTapSignIn_shouldDlegateSignInPresentation() {
        // given
        let sut = makeSUT()

        // when
        sut.didTapSignIn()

        // then
        XCTAssertEqual(didRequestSignInCount, 1)
    }

    func test_submitOnNameField_shouldChangeFocusToEmail() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Change focus to email")

        sut.$focusedField
            .dropFirst()
            .sink { field in
                XCTAssertEqual(field, .email)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.submit(.name)

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

    func test_submitOnPasswordField_shouldChangeFocusToConfirmPassword() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Change focus to confirmPassword")

        sut.$focusedField
            .dropFirst()
            .sink { field in
                XCTAssertEqual(field, .confirmPassword)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.submit(.password)

        // then
       wait(for: [expectation], timeout: 1)
    }

    func test_submitOnConfirmPasswordField_withInvalidInputShouldResignFocus() {
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
        sut.submit(.confirmPassword)

        // then
       wait(for: [expectation], timeout: 1)
    }

    func test_submitOnConfirmPasswordField_withValidInputShouldCreateAccount() async {
        // given
        let sut = makeSUT()

        sut.name = "Test"
        sut.email = "test@gmail.com"
        sut.password = "test123456"
        sut.confirmPassword = "test123456"

        // when
        sut.submit(.confirmPassword)

        try? await Task.sleep(for: .seconds(1))

        // then
        XCTAssertEqual(didAuthenticateCount, 1)
    }

    // MARK: - Helpers

    func makeSUT(users: [String : (user: UserDTO, password: String)] = [:]) -> SignUpViewModel {
        SignUpViewModel(
            authCoordinating: self,
            errorHandler: ErrorHandler<AuthError>(),
            signUpUseCase: SignUpUseCase(
                authRepository: AuthRepository(
                    dataSource: FirebaseAuthDataSourceMock()
                ),
                validateNameUseCase: ValidateNameUseCase(),
                validateEmailUseCase: ValidateEmailUseCase(),
                confirmPasswordUseCase: ConfirmPasswordUseCase(
                    validatePasswordUseCase: ValidatePasswordUseCase()
                )
            )
        )
    }
}

extension SignUpViewModelTests: AuthCoordinating {

    func didAuthenticate() {
        didAuthenticateCount += 1
    }

    func didRequestSignIn() {
        didRequestSignInCount += 1
    }
}
