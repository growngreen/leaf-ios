//
//  Shake.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import SwiftUI

struct Shake: AnimatableModifier {
    var shakes: CGFloat = 0

    var animatableData: CGFloat {
        get {
            shakes
        } set {
            shakes = newValue
        }
    }

    func body(content: Content) -> some View {
        content
            .offset(x: sin(shakes * .pi * 2) * 10)
    }
}
