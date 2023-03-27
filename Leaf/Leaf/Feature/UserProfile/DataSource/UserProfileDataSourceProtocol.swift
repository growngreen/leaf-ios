//
//  UserProfileDataSource.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 2.03.23.
//

import Foundation

protocol UserProfileDataSourceProtocol {
    var userProfile: UserProfileDTO? { get }
    func updateProfile(name: String?, image: String?) async throws -> UserProfileDTO
}
