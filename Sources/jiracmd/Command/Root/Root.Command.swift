//
//  Root.Command.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Core

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
}
