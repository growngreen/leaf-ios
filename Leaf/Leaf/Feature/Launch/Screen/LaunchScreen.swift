//
//  LaunchScreen.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 15.03.23.
//

import SwiftUI

struct LaunchScreen: View {

    @ObservedObject private var viewModel: LaunchViewModel
    @State private var animate: Bool = false

    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {
            backgroundColor
            icon
                .scaleEffect(animate ? 4 : 1)
        }
        .opacity(animate ? 0 : 1)
        .ignoresSafeArea(.all)
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(1))

                await MainActor.run(body: {
                    withAnimation(.easeOut(duration: 0.5)) {
                        animate = true
                    }
                })
            }
        }
        .task {
            await viewModel.checkAuthState()
        }
    }
}

private extension LaunchScreen {

    var backgroundColor: some View {
       Color(red: 34 / 255, green: 139 / 255, blue: 34 / 255)
            .ignoresSafeArea(.all)
    }

    var icon: some View {
        Image(systemName: "leaf")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 175, height: 175)
            .foregroundColor(.white)
    }
}
