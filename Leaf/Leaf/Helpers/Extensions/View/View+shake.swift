//
//  View+shake.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 28.03.23.
//

import SwiftUI

extension View {
    func shake(with shakes: CGFloat) -> some View {
        modifier(Shake(shakes: shakes))
    }
}
