//
//  RootCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum RootCommand: String, CommandList {
    static var usageDescription: String {
        let values = elements.map { element -> String in
            switch element {
            case .register:
                return ""
            case .search:
                return ""
            }
        }
        return "Usage:\n"
    }

    case register
    case search
}
