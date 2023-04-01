//
//  SignUpScreen.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import SwiftUI

struct SignUpScreen: View {

    @ObservedObject private var viewModel: SignUpViewModel
    @FocusState private var focusedField: SignUpViewModel.SignUpField?

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            Section {
                nameTextField
                emailTextField
                passwordTextField
                confirmPasswordTextField
            } footer: {
                sectionFooterText
            }

            Section {
                submitButton
            }
            .disabled(viewModel.isSubmitButtonDisabled)
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .navigationTitle(R.string.localizable.sign_up_title())
        .onReceive(viewModel.$focusedField) { field in
            focusedField = field
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error, actions: {})
    }
}

private extension SignUpScreen {

    var nameTextField: some View {
        TextField(
            R.string.localizable.name_text_field_title(),
            text: $viewModel.name,
            prompt: Text(R.string.localizable.name_text_field_title())
        )
        .focused($focusedField, equals: .name)
        .textContentType(.name)
        .onSubmit {
            viewModel.submit(.name)
        }
    }

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
    }

    var confirmPasswordTextField: some View {
        SecureField(
            R.string.localizable.confirm_password_text_field_title(),
            text: $viewModel.confirmPassword,
            prompt: Text(R.string.localizable.confirm_password_text_field_title())
        )
        .focused($focusedField, equals: .confirmPassword)
        .textContentType(.password)
        .submitLabel(.done)
        .onSubmit {
            viewModel.submit(.confirmPassword)
        }
    }

    var sectionFooterText: some View {
        Text(R.string.localizable.sign_up_section_footer_text())
    }

    var submitButton: some View {
        Button(R.string.localizable.create_account_button_title()) {
            viewModel.signUp()
        }
    }

    var footerText: some View {
        HStack(spacing: 5) {
            Text(R.string.localizable.sign_up_footer_text())
            Button(R.string.localizable.sign_up_sign_in_footer_text()) {
                viewModel.didTapSignIn()
            }
        }
    }
}
