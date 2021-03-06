//
//  AliasJQL.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core
import Foundation

enum AliasJQL {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        do {
            switch command {
            case .add:
                try Add.run(parser, facade: facade)
            case .remove:
                try Remove.run(parser, facade: facade)
            case .list:
                try List.run(parser, facade: facade)
            }
        } catch {
            let commands = parser.commands.dropLast().map { $0 }
            let usage = AliasJQL.Command.usageDescription(commands)
            throw Root.Error(inner: error, usage: usage)
        }
    }

    enum Command: String, CommandList {
        case add
        case remove
        case list
    }

    enum Error: Swift.Error {
        case noName
        case noJQL
    }

    enum Add {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                throw Error.noName
            }

            guard let jql = parser.shift(), !jql.isEmpty else {
                throw Error.noJQL
            }

            try facade.jql.addAlias(name: name, jql: jql)
        }
    }

    enum Remove {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                throw Error.noName
            }

            try facade.jql.removeAlias(name: name)
        }
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let aliases = try facade.jql.aliases()

            print("Registered Jira Query Language Aliases:\n")
            aliases.forEach {
                print("\tname: \($0.name), jql: \($0.jql)")
            }
        }
    }
}

extension AliasJQL.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noName:
            return "NAME is required parameter."
        case .noJQL:
            return "JQL is required parameter."
        }
    }
}
