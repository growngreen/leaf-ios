//
//  SignUpViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 16.03.23.
//

import Foundation
import Combine

class SignUpViewModel: BaseViewModel {

    enum SignUpField {
        case name
        case email
        case password
        case confirmPassword
    }

    @Published private(set) var isSubmitButtonDisabled: Bool = true
    @Published private(set) var focusedField: SignUpField?

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    private weak var authCoordinating: SignUpCoordinating?

    private let signUpUseCase: SignUpUseCase

    private var signUpTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    private var isValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    init(
        authCoordinating: SignUpCoordinating?,
        errorHandler: any ErrorHandlerProtocol,
        signUpUseCase: SignUpUseCase
    ) {
        self.authCoordinating = authCoordinating
        self.signUpUseCase = signUpUseCase

        super.init(errorHandler: errorHandler)

        bind()
    }

    func signUp() {
        signUpTask?.cancel()
        signUpTask = Task(operation: { [weak self] in
            guard let self = self else { return }

            do {
                try await self.signUpUseCase.execute(name: name, email: email, password: password, confirmPassword: confirmPassword)

                await MainActor.run(body: {
                    self.authCoordinating?.didSignUp()
                })
            } catch {
                self.handle(error)
            }
        })
    }

    func didTapSignIn() {
        authCoordinating?.didRequestSignIn()
    }

    func submit(_ field: SignUpField) {
        switch field {
        case .name:
            focusedField = .email
        case .email:
            focusedField = .password
        case .password:
            focusedField = .confirmPassword
        case .confirmPassword:
            guard isValid else {
                focusedField = nil
                return
            }
            signUp()
        }
    }

    private func bind() {
        Publishers.CombineLatest4($name, $email, $password, $confirmPassword)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] name, email, password, confirmPassword in
                guard let self else { return }

                self.isSubmitButtonDisabled = !self.isValid
            }
            .store(in: &cancellables)
    }
}
