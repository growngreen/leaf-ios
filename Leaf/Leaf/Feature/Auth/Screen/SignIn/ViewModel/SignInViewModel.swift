//
//  SignInViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {

    enum SignInField {
        case email
        case password
    }

    private weak var signInCoordinating: SignInCoordinating?

    @Published var focusedField: SignInField? = nil
    @Published private(set) var isSubmitButtonDisabled: Bool = true

    @Published var email: String = ""
    @Published var password: String = ""

    private let signInUseCase: SignInUseCase

    private var signInTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    private var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    init(
        signInCoordinating: SignInCoordinating,
        signInUseCase: SignInUseCase
    ) {
        self.signInCoordinating = signInCoordinating
        self.signInUseCase = signInUseCase

        bind()
    }

    func submit(_ field: SignInField) {
        switch field {
        case .email:
            focusedField = .password
        case .password:
            guard isValid else {
                focusedField = nil
                return
            }
            signIn()
        }
    }

    func signIn() {
        signInTask?.cancel()
        signInTask = Task { [weak self] in
            guard let self else { return }

            do {
                try await self.signInUseCase.execute(email: self.email, password: self.password)

                await MainActor.run(body: {
                    self.signInCoordinating?.didSignIn()
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func didTapSignUp() {
        signInCoordinating?.didRequestSignUp()
    }

    private func bind() {
        Publishers.CombineLatest($email, $password)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] _, _ in
                guard let self else { return }

                self.isSubmitButtonDisabled = !self.isValid
            }
            .store(in: &cancellables)
    }
}
