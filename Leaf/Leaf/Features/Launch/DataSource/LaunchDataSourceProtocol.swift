//
//  LaunchDataSourceProtocol.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation

protocol LaunchDataSourceProtocol {
    func isAuthenticated() async -> Bool
}
