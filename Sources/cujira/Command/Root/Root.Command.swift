//
//  Root.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Core
import Foundation

enum Root {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .register:
            try Register.run(parser)

        case .issue:
            try Issue.run(parser)

        case .board:
            try Board.run(parser)

        case .sprint:
            try Sprint.run(parser)

        case .alias:
            try Alias.run(parser)
        }
    }

    enum Command: String, CommandList {
        case alias
        case board
        case issue
        case register
        case sprint
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
