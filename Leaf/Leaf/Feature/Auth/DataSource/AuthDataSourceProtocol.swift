//
//  AuthDataSourceProtocol.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 6.02.23.
//

import Foundation

protocol AuthDataSourceProtocol {
    var currentUser: UserDTO? { get }
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() async throws
}
