//
//  InputTextField.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import SwiftUI

struct InputTextField: View {

    enum Constants {
        // Text Field
        static let textFieldFontSize: CGFloat = 18
        static let textFieldLeadingPadding: CGFloat = 10
        static let textFieldBorderCornerRadius: CGFloat = 8
        static let textFieldDefaultHeight: CGFloat = 50

        // Floating Text
        static let floatingTextFontSize: CGFloat = 14
        static let floatingTextLeadingPadding: CGFloat = 10

        // Colors
        static let invalidColor: Color = .red.opacity(0.5)
        static let defaultColor: Color = .secondary.opacity(0.5)

        // Error Text
        static let errorTextFontSize: CGFloat = 12
        static let errorTextViewTopPadding: CGFloat = 5

        // Animation
        static let animationDuretion: CGFloat = 0.2
    }

    // MARK: - Properties

    @Binding var content: String

    let title: String
    let contentType: UITextContentType
    let keyboardType: UIKeyboardType
    let borderColor: Color
    let height: CGFloat
    let isSecure: Bool
    let isValid: Bool
    let errorMessage: String
    let onSubmit: () -> Void

    // MARK: - init

    init(
        content: Binding<String>,
        title: String,
        contentType: UITextContentType,
        keyboardType: UIKeyboardType = .default,
        borderColor: Color = Constants.defaultColor,
        height: CGFloat = Constants.textFieldDefaultHeight,
        isSecure: Bool,
        isValid: Bool,
        errorMessage: String,
        onSubmit: @escaping () -> Void
    ) {
        self._content = content
        self.title = title
        self.contentType = contentType
        self.keyboardType = keyboardType
        self.borderColor = borderColor
        self.height = height
        self.isSecure = isSecure
        self.isValid = isValid
        self.errorMessage = errorMessage
        self.onSubmit = onSubmit
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {

            ZStack(alignment: .topLeading) {

                VStack {
                    if isSecure {
                        secureTextFieldView
                    } else {
                        textFieldView
                    }
                }
                .frame(height: height)
                .padding(.leading, Constants.textFieldLeadingPadding)
                .background(content: {
                    textFieldBorderView
                })

                floatingTitleView
                    .padding(.leading, Constants.floatingTextLeadingPadding)
            }

            errorMessageView
                .padding(.top, Constants.errorTextViewTopPadding)
        }
        .shake(with: isValid ? 0 : 2)
        .animation(.easeIn(duration: Constants.animationDuretion), value: content)
        .animation(.easeIn(duration: Constants.animationDuretion), value: isValid)
    }
}

// MARK: - Components

private extension InputTextField {

    var textFieldView: some View {

        TextField(title, text: $content)
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .font(.system(size: Constants.textFieldFontSize))
            .onSubmit {
                onSubmit()
            }
    }

    var secureTextFieldView: some View {

        SecureField(title, text: $content)
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .font(.system(size: Constants.textFieldFontSize))
            .onSubmit {
                onSubmit()
            }
    }

    var textFieldBorderView: some View {

        RoundedRectangle(cornerRadius: Constants.textFieldBorderCornerRadius)
            .stroke(isValid ? borderColor : Constants.invalidColor)
    }

    var floatingTitleView: some View {

        Text(title)
        .foregroundColor(isValid ? Constants.defaultColor : Constants.invalidColor)
        .font(.system(size: content.isEmpty ? Constants.textFieldFontSize : Constants.floatingTextFontSize))
        .background(content: {
            Color.white
                .padding(.horizontal, -2)
        })
        .offset(x: .zero , y: content.isEmpty ? 10 : -10)
        .opacity(content.isEmpty ? .zero : 1)
    }

    var errorMessageView: some View {

        Text(errorMessage)
            .opacity(isValid ? .zero : 1)
            .font(.system(size: Constants.errorTextFontSize))
            .multilineTextAlignment(.leading)
            .foregroundColor(Constants.invalidColor)
    }
}
