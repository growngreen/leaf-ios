//
//  LoadingModifier.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 6.04.23.
//

import SwiftUI

struct LoadingModifier: ViewModifier {

    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!isLoading)
            .overlay {
                if isLoading {
                    ZStack {
                        backgroundView
                        loadingView
                    }
                }
            }
    }
}

extension LoadingModifier {

    var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .tint(.white)
            .scaleEffect(1.5)
    }

    var backgroundView: some View {
        Color.black
            .opacity(0.5)
            .ignoresSafeArea(.all)
    }
}
