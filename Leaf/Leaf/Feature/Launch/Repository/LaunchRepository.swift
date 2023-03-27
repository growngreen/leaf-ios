//
//   .swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 26.03.23.
//

import Foundation

class LaunchRepository: LaunchRepositoryProtocol {

    private let dataSource: LaunchDataSourceProtocol

    init(dataSource: LaunchDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func isAuthenticated() async -> AuthState {
        let isAuthenticated = await dataSource.isAuthenticated()

        if isAuthenticated {
            return .authenticated
        } else {
            return .unautheticated
        }
    }
}
