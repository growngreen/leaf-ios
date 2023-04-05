//
//  UserGreetingUseCase.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import Foundation

class UserGreetingUseCase {

    func execute(with name: String?) -> String {

        let greeting: String

        let fullNameArr = name?.split(separator: " ")

        if let firstName = fullNameArr?.first {
            greeting = "\(R.string.localizable.home_greeting_word()) \(firstName)"
        } else {
            greeting = R.string.localizable.home_greeting_default()
        }

        return greeting
    }
}
