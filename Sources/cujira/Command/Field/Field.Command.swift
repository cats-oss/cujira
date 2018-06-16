//
//  Field.Command.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Core
import Foundation

enum Field {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        do {
            switch command {
            case .list:
                try List.run(parser, facade: facade)
            }
        } catch {
            throw Root.Error(inner: error, usage: Field.Command.usageDescription(parser.root))
        }
    }

    enum Command: String, CommandList {
        case list
    }

    enum List {
        enum Error: Swift.Error {
            case noParameter
        }

        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let fields: [Core.Field]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                fields = try facade.issue.fields(userCache: false)
            } else {
                fields = try facade.issue.fields()
            }

            print("Results:")
            if fields.isEmpty {
                print("\n\tEmpty")
            } else {
                fields.forEach { field in
                    print("""
                        
                        id: \(field.id)
                        name: \(field.name)
                        custom: \(field.custom)
                    """)
                }
            }
        }
    }
}
