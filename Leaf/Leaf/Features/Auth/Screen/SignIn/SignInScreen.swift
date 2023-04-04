//
//  SignInScreen.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import SwiftUI

struct SignInScreen: View {

    @ObservedObject private var viewModel: SignInViewModel
    @FocusState private var focusedField: SignInViewModel.SignInField?

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    emailTextField
                    passwordTextField
                } footer: {
                    sectionFooterText
                }

                Section {
                    submitButton
                }
                .disabled(viewModel.isSubmitButtonDisabled)
            }

            footerText
                .padding()
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .navigationTitle(R.string.localizable.sign_in_title())
        .onReceive(viewModel.$focusedField) { field in
            focusedField = field
        }
    }
}

private extension SignInScreen {

    var emailTextField: some View {
        TextField(
            R.string.localizable.email_text_field_title(),
            text: $viewModel.email,
            prompt: Text(R.string.localizable.email_text_field_title())
        )
        .focused($focusedField, equals: .email)
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
        .onSubmit {
            viewModel.submit(.email)
        }
    }

    var passwordTextField: some View {
        SecureField(
            R.string.localizable.password_text_field_title(),
            text: $viewModel.password,
            prompt: Text(R.string.localizable.password_text_field_title())
        )
        .focused($focusedField, equals: .password)
        .textContentType(.password)
        .onSubmit {
            viewModel.submit(.password)
        }
        .submitLabel(.done)
    }

    var sectionFooterText: some View {
        Text(R.string.localizable.sign_in_section_footer_text())
    }

    var submitButton: some View {
        Button(R.string.localizable.sign_in_button_title()) {
            viewModel.signIn()
        }
    }

    var footerText: some View {
        HStack(spacing: 5) {
            Text(R.string.localizable.sign_in_footer_text())
            Button(R.string.localizable.sign_in_sign_in_footer_text()) {
                viewModel.didTapSignUp()
            }
        }
    }
}

