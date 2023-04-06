//
//  View+loading.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 6.04.23.
//

import SwiftUI

extension View {
    
    func isLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
