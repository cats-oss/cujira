//
//  Alias.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/07.
//

enum Alias {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .project:
            try AliasProject.run(parser)

        case .jql:
            try AliasJQL.run(parser)
        }
    }

    enum Command: String, CommandList {
        case project
        case jql
    }
}
