//
//  AlertPresenter.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation
import UIKit

struct ActionSheetButton {

    enum Style {
        case `default`
        case cancel
        case destructive
    }

    let title: String
    let style: Style
    let action: () -> Void
}

protocol AlertPresenterProtocol {
    func showAlert(with title: String?, message: String)
    func showActionSheet(with title: String?, message: String?, actions: [ActionSheetButton])
}

class AlertPresenter: AlertPresenterProtocol {

    func showAlert(with title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        rootViewController?.present(alert, animated: true)
    }

    func showActionSheet(with title: String?, message: String?, actions: [ActionSheetButton]) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actions.forEach { action in
            actionSheet.addAction(
                UIAlertAction(
                    title: action.title,
                    style: style(from: action.style),
                    handler: { _ in
                        action.action()
                    }
                )
            )
        }

        rootViewController?.present(actionSheet, animated: true)
    }
}

extension AlertPresenter: ErrorPresenting {

    func presentErrorAlert(with message: String) {
        showAlert(with: nil, message: message)
    }
}

private extension AlertPresenter {

    var rootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow})
                .first?.rootViewController
    }

    func style(from actionSheetButtonStyle: ActionSheetButton.Style) -> UIAlertAction.Style {
        switch actionSheetButtonStyle {
        case .default:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}
