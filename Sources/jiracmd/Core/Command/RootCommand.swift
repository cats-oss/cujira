//
//  RootCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum Root {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .register:
            try Register.run(parser)

        case .issues:
            try Issues.run(parser)

        case .boards:
            try Boards.run(parser)

        case .sprints:
            try Sprints.run(parser)

        case .alias:
            try Alias.run(parser)
        }
    }

    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .register:
                    return ""
                case .issues:
                    return ""
                case .boards:
                    return ""
                case .sprints:
                    return ""
                case .alias:
                    return ""
                }
            }
            return "Usage:\n"
        }

        case register
        case alias
        case issues
        case boards
        case sprints
    }
}
