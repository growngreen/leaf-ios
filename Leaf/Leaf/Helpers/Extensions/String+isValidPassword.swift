//
//  String+isValidPassword.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 7.02.23.
//

import Foundation

extension String {
    var isValidPassword: Bool {
        guard !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        return self.count > 6
    }
}
