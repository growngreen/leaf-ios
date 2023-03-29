//
//  SignUpViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 16.03.23.
//

import Foundation

class SignUpViewModel: ObservableObject {

    enum Field {
        case fullName
        case email
        case password
        case confirmPassword
    }

    // MARK: - Properties

    @Published private(set) var invalidField: Field?
    @Published private(set) var focusedField: Field? = .fullName

    private weak var authCoordinating: AuthCoordinating?

    private let confirmPasswordUseCase: ConfirmPasswordUseCase
    private let validateEmailUseCase: ValidateEmailUseCase
    private let validateNameUseCase: ValidateNameUseCase
    private let signUpUseCase: SignUpUseCase

    private var signUpTask: Task<Void, Never>?

    var title: String {
        "Sign up"
    }

    var fullNameTextFieldTitle: String {
        "Full Name"
    }

    var fullNameTextFieldErrorMessage: String {
        "Invalid name"
    }

    var emailTextFieldTitle: String {
        "E-mail"
    }

    var emailTextFieldErrorMessage: String {
        "Invalid e-mail"
    }

    var passwordTextFieldTitle: String {
        "Password"
    }

    var passwordTextFieldErrorMessage: String {
        "Invalid password"
    }

    var confirmPasswordTextFieldTitle: String {
        "Confirm Password"
    }

    var confirmPasswordFieldErrorMessage: String {
        "Invalid password"
    }

    var createAccountButtonTitle: String {
        "Create account"
    }

    var footerText: String {
        "Already got an account?"
    }

    var signInFooterText: String {
        "Sign in"
    }

    // MARK: - init

    init(
        authCoordinating: AuthCoordinating,
        confirmPasswordUseCase: ConfirmPasswordUseCase,
        validateEmailUseCase: ValidateEmailUseCase,
        validateNameUseCase: ValidateNameUseCase,
        signUpUseCase: SignUpUseCase
    ) {
        self.authCoordinating = authCoordinating
        self.validateEmailUseCase = validateEmailUseCase
        self.validateNameUseCase = validateNameUseCase
        self.confirmPasswordUseCase = confirmPasswordUseCase
        self.signUpUseCase = signUpUseCase
    }

    // MARK: - Public

    func validate(
        fullName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) {
        guard validateName(fullName) else {
            invalidField = .fullName
            return
        }

        guard validateEmail(email) else {
            invalidField = .email
            return
        }

        guard validatePssword(password, passwordConfirmation: passwordConfirmation) else {
            invalidField = .password
            return
        }

        signUp(with: email, password: password)
    }

    func didTapSignIn() {
        authCoordinating?.didRequestSignIn()
    }

    func onSubmit(on field: Field) {
        switch field {
        case .fullName:
            focusedField = .email
        case .email:
            focusedField = .password
        case .password:
            focusedField = .confirmPassword
        case .confirmPassword:
            focusedField = nil
        }
    }
}

// MARK: - Private

private extension SignUpViewModel {

    func validateName(_ fullName: String) -> Bool {
        validateNameUseCase.execute(fullName)
    }

    func validateEmail(_ email: String) -> Bool {
        validateEmailUseCase.execute(email)
    }

    func validatePssword(_ password: String, passwordConfirmation: String) -> Bool {
        confirmPasswordUseCase.execute(password: password, passwordConfirmation: passwordConfirmation)
    }

    func signUp(with email: String, password: String) {
        signUpTask?.cancel()
        signUpTask = Task(operation: {
            do {
                try await signUpUseCase.execute(email: email, password: password)
                authCoordinating?.didAuthenticate()
            } catch {
                handle(error)
            }
        })
    }

    func handle(_ error: Error) {
        print("\(error.localizedDescription)")
    }
}
