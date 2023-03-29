//
//  SignUpScreen.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import SwiftUI

struct SignUpScreen: View {

    @ObservedObject private var viewModel: SignUpViewModel

    @State private var fullNameTextField: String = ""
    @State private var emailTextField: String = ""
    @State private var passwordTextField: String = ""
    @State private var confirmPasswordTextField: String = ""

    @FocusState private var focusedField: SignUpViewModel.Field?

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {

            VStack {
                Spacer()

                textFieldSection
                    .padding([.top, .bottom])

                createAccountButton
                    .padding()

                Spacer()

                footerText
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(viewModel.title)
            .padding()
        }
        .onTapGesture { focusedField = nil }
        .onReceive(viewModel.$focusedField) { focusedField = $0 }
    }
}

// MARK: - Components

private extension SignUpScreen {

    var textFieldSection: some View {

        VStack(spacing: 15) {

            InputTextField(
                content: $fullNameTextField,
                title: viewModel.fullNameTextFieldTitle,
                contentType: .name,
                isSecure: false,
                isValid: viewModel.invalidField != .fullName,
                errorMessage: viewModel.fullNameTextFieldErrorMessage,
                onSubmit: { viewModel.onSubmit(on: .fullName) }
            )
                .focused($focusedField, equals: .fullName)

            InputTextField(
                content: $emailTextField,
                title: viewModel.emailTextFieldTitle,
                contentType: .emailAddress,
                keyboardType: .emailAddress,
                isSecure: false,
                isValid: viewModel.invalidField != .email,
                errorMessage: viewModel.emailTextFieldErrorMessage,
                onSubmit: { viewModel.onSubmit(on: .email) }
            )
                .focused($focusedField, equals: .email)

            InputTextField(
                content: $passwordTextField,
                title: viewModel.passwordTextFieldTitle,
                contentType: .password,
                isSecure: true,
                isValid: viewModel.invalidField != .password,
                errorMessage: viewModel.passwordTextFieldErrorMessage,
                onSubmit: { viewModel.onSubmit(on: .password) }
            )
                .focused($focusedField, equals: .password)

            InputTextField(
                content: $confirmPasswordTextField,
                title: viewModel.confirmPasswordTextFieldTitle,
                contentType: .password,
                isSecure: true,
                isValid: viewModel.invalidField != .password,
                errorMessage: viewModel.confirmPasswordFieldErrorMessage,
                onSubmit: { viewModel.onSubmit(on: .confirmPassword) }
            )
                .focused($focusedField, equals: .confirmPassword)
        }
    }

    var createAccountButton: some View {

        Button(action: {
            viewModel.validate(
                fullName: fullNameTextField,
                email: emailTextField,
                password: passwordTextField,
                passwordConfirmation: confirmPasswordTextField
            )
        }, label: {
            Text(viewModel.createAccountButtonTitle)
                .foregroundColor(.white)
                .background(content: {
                    Color.blue.opacity(0.8)
                        .frame(maxWidth: .infinity)
                })
        })
        .frame(maxWidth: .infinity)
        .frame(height: 50)
    }

    var footerText: some View {

        HStack(spacing: 5) {
            Text(viewModel.footerText)
            Button(viewModel.signInFooterText) {
                viewModel.didTapSignIn()
            }
        }
    }
}
