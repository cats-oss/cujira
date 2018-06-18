//
//  AliasCustomField.Command.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Core
import Foundation

enum AliasCustomField {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        do {
            switch command {
            case .epiclink:
                try UpdateAlias.run(parser, facade: facade, dependency: .epiclink)
            case .storypoint:
                try UpdateAlias.run(parser, facade: facade, dependency: .storypoint)
            case .list:
                try List.run(parser, facade: facade)
            }
        } catch {
            throw Root.Error(inner: error, usage: AliasCustomField.Command.usageDescription(command.rawValue))
        }
    }

    enum Command: String, CommandList {
        case epiclink
        case storypoint
        case list
    }

    enum UpdateAlias {
        enum Error: Swift.Error {
            case noID
        }

        static func run(_ parser: ArgumentParser, facade: Facade, dependency: FieldAlias.Name) throws {
            guard let id = parser.shift(), !id.isEmpty else {
                throw Error.noID
            }

            try facade.field.addAlias(name: dependency, withFieldID: id)
        }
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let aliases = try facade.field.aliases()

            print("Registered Custom Field Aliases:\n")
            aliases.forEach {
                print("""
                name: \($0.name.rawValue)
                    fieldID: \($0.field.id)
                    fieldName: \($0.field.name)
                """)
            }
        }
    }
}

extension AliasCustomField.UpdateAlias.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noID:
            return "[FIELD_ID] is a required parameter."
        }
    }
}
