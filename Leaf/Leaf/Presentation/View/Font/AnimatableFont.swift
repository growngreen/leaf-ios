//
//  AnimatableFont.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import SwiftUI

struct AnimatableFont: AnimatableModifier {
    var size: CGFloat

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}
