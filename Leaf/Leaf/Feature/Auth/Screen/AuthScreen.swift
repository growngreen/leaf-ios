//
//  AuthScreen.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import SwiftUI

struct AuthScreen: View {

    @ObservedObject private var viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Auth")

            Spacer()

            Button("Authenticate") {
                viewModel.authenticate()
            }
        }
    }
}
