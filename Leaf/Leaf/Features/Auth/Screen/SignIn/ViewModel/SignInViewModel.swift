//
//  SignInViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import Foundation
import Combine

class SignInViewModel: BaseViewModel {

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
        alertPresenter: AlertPresenterProtocol,
        errorHandler: ErrorHandlerProtocol,
        signInCoordinating: SignInCoordinating,
        signInUseCase: SignInUseCase
    ) {
        self.signInCoordinating = signInCoordinating
        self.signInUseCase = signInUseCase

        super.init(errorHandler: errorHandler, alertPresenter: alertPresenter)

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
        startLoading()
        signInTask?.cancel()
        signInTask = Task { [weak self] in
            guard let self else { return }

            do {
                try await self.signInUseCase.execute(email: self.email, password: self.password)

                await MainActor.run(body: {
                    stopLoading()
                    self.signInCoordinating?.didSignIn()
                })
            } catch {
                stopLoading()
                await handle(error)
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
