//
//  AuthRepositoryProtocol.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 17.02.23.
//

import Foundation

protocol AuthRepositoryProtocol {
    var currentUser: User? { get }
    func signUp(name: String, email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() async throws
}
