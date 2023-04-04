//
//  UserProfileRepositoryProtocol.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

protocol UserProfileRepositoryProtocol {
    var userProfile: UserProfile? { get }
    func updateProfile(name: String?, image: String?) async throws -> UserProfile
}
