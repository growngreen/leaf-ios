//
//  FirebaseLaunchDataSource.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation
import Firebase

class FirebaseLaunchDataSource: LaunchDataSourceProtocol {

    private let auth: Auth

    init(auth: Auth) {
        self.auth = auth
    }

    func isAuthenticated() async -> Bool {
        auth.currentUser != nil
    }
}
