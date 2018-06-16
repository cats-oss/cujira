//
//  Alias.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/07.
//

import Core

enum Alias {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()
        switch command {
        case .project:
            try AliasProject.run(parser, facade: facade)

        case .jql:
            try AliasJQL.run(parser, facade: facade)

        case .customfield:
            try AliasCustomField.run(parser, facade: facade)
        }
    }

    enum Command: String, CommandList {
        case project
        case jql
        case customfield
    }
}
