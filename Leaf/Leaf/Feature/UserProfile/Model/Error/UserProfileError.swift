//
//  UserProfileError.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation

enum UserProfileError: Error {
    case noUser
    case noName
    case noEmail
    case invalidName
    case invalidImage
}
