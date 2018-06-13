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
            throw Root.Error(inner: error, usage: AliasJQL.Command.usageDescription(parser.root))
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

            try facade.jqlService.addAlias(name: name, jql: jql)
        }
    }

    enum Remove {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                throw Error.noName
            }

            try facade.jqlService.removeAlias(name: name)
        }
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let aliases = try facade.jqlService.loadAliases()

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
