//
//  AliasCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

import Core

enum Alias {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .project:
            try Project.run(parser)

        case .jql:
            try JQL.run(parser)
        }
    }

    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .project:
                    return ""
                case .jql:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }
        case project
        case jql
    }
}
