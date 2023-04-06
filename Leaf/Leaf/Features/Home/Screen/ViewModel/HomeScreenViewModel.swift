//
//  HomeScreenViewModel.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

class HomeScreenViewModel: BaseViewModel {

    private let currentUserNameUseCase: CurrentUserNameUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    private let userGreetingUseCase: UserGreetingUseCase

    private var signOutTask: Task<Void, Never>?

    weak var homeCoordinating: HomeCoordinating?

    init(
        homeCoordinating: HomeCoordinating,
        alertPresenter: AlertPresenterProtocol,
        errorHandler: ErrorHandlerProtocol,
        userGreetingUseCase: UserGreetingUseCase,
        signOutUseCase: SignOutUseCaseProtocol,
        currentUserNameUseCase: CurrentUserNameUseCaseProtocol
    ) {
        self.homeCoordinating = homeCoordinating
        self.userGreetingUseCase = userGreetingUseCase
        self.currentUserNameUseCase = currentUserNameUseCase
        self.signOutUseCase = signOutUseCase

        super.init(errorHandler: errorHandler, alertPresenter: alertPresenter)
    }

    var title: String {
        let userName = currentUserNameUseCase.execute()
        return userGreetingUseCase.execute(with: userName)
    }

    func tapOptionsButton() {
        alertPresenter.showActionSheet(
            with: nil,
            message: nil,
            actions: signOutSheetButtons()
        )
    }
}

private extension HomeScreenViewModel {

    func signOutSheetButtons() -> [ActionSheetButton] {
        let cancel = ActionSheetButton(
            title: R.string.localizable.general_cancel_button_title(),
            style: .cancel,
            action: {}
        )
        let signOutButton = ActionSheetButton(
            title: R.string.localizable.home_sign_out_title(),
            style: .destructive,
            action: { [weak self] in
                self?.presentSignOutConfirmationAlert()
            }
        )

        return [signOutButton, cancel]
    }

    func signOutConfirmationAlertButtons() -> [ActionSheetButton] {
        let cancel = ActionSheetButton(
            title: R.string.localizable.general_cancel_button_title(),
            style: .cancel,
            action: {}
        )
        let signOut = ActionSheetButton(
            title: R.string.localizable.home_sign_out_title(),
            style: .destructive,
            action: { [weak self] in
                self?.signOut()
            }
        )

        return [cancel, signOut]
    }

    func presentSignOutConfirmationAlert() {
        alertPresenter.showAlert(
            with: nil,
            message: R.string.localizable.home_sign_out_confirmation_message(),
            actions: signOutConfirmationAlertButtons()
        )
    }

    func signOut() {
        startLoading()
        signOutTask?.cancel()
        signOutTask = Task { [weak self] in
            do {
                try await self?.signOutUseCase.execute()

                await MainActor.run(body: { [weak self] in
                    stopLoading()
                    self?.homeCoordinating?.didSignedOut()
                })
            } catch {
                stopLoading()
                await self?.handle(error)
            }
        }
    }
}
