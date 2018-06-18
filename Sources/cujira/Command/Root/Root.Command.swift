//
//  Root.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Core
import Foundation

enum Root {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()
        switch command {
        case .register:
            try Register.run(parser, facade: facade)

        case .issue:
            try Issue.run(parser, facade: facade)

        case .alias:
            try Alias.run(parser, facade: facade)

        case .list:
            try List.run(parser, facade: facade)
        }
    }

    enum Command: String, CommandList {
        case alias
        case issue
        case list
        case register
    }

    struct Error: Swift.Error {
        let inner: Swift.Error
        let usage: String
    }
}

extension Root.Error: LocalizedError {
    var errorDescription: String? {
        let error = (inner as? LocalizedError)?.errorDescription ?? "\(inner)"
        return """
        \(error)

        \(usage)
        """
    }
}
