//
//  List.Field.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/18.
//

import Core
import Foundation

extension List {
    enum Field {
        enum Error: Swift.Error {
            case noParameter
        }

        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let fields: [Core.Field]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                fields = try facade.field.fields(useCache: false)
            } else {
                fields = try facade.field.fields(useCache: true)
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

extension List.Field: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show fields from cache.
        """
    }

    static func usageDescriptionAndOptions(_ cmd: String) -> String {
        return usageDescription(cmd) + """


            Options:

                -f | --fetch
                    ... Fetch from API.
        """
    }
}
