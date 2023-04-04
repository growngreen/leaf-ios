//
//  BaseViewModelTests.swift
//  LeafTests
//
//  Created by Tsvetan Tsvetanov on 1.04.23.
//

import Foundation
import XCTest
import Combine
@testable import Leaf

final class BaseViewModelTests: XCTestCase {

    enum TestLocalizedError: LocalizedError {
        case test
    }

    enum TestError: Error {
        case test
    }

    private var cancellables = Set<AnyCancellable>()

    func test_handle_shouldSetHasErrorToTrue() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Should set hasError to true")

        sut.$hasError
            .dropFirst()
            .sink { hasError in
                XCTAssertTrue(hasError)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.handle(AuthError.mismatchedPassword)

        // then
        wait(for: [expectation], timeout: 1)
    }

    func test_handle_shouldSetError() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Should set error")

        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.handle(AuthError.mismatchedPassword)

        // then
        wait(for: [expectation], timeout: 1)
    }

    func test_handle_withAuthError_shouldSetSystemError() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Should set systemError")

        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, .system(AuthError.mismatchedPassword))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.handle(AuthError.mismatchedPassword)

        // then
        wait(for: [expectation], timeout: 1)
    }

    func test_handle_withLocalizedError_shouldSetLocalizedError() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Should set localizedError")

        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, .localized(TestLocalizedError.test))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.handle(TestLocalizedError.test)

        // then
        wait(for: [expectation], timeout: 1)
    }

    func test_handle_withDefaultError_shouldSetDefaultError() {
        // given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Should set default error")

        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, .default(TestError.test))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // when
        sut.handle(TestError.test)

        // then
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    func makeSUT() -> BaseViewModel {
        BaseViewModel(errorHandler: ErrorHandler<AuthError>())
    }
}
