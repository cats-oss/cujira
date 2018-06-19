//
//  List.IssueType.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/19.
//

import Core
import Foundation

extension List {
    enum IssueType {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let types: [Core.IssueType]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                types = try facade.issue.issueTypes(useCache: false)
            } else {
                types = try facade.issue.issueTypes(useCache: true)
            }

            print("Results:")
            if types.isEmpty {
                print("\n\tEmpty")
            } else {
                types.forEach { type in
                    print("""

                        id: \(type.id)
                        name: \(type.name)
                        description: \(type.description)
                        subtask: \(type.subtask)
                    """)
                }
            }
        }
    }
}

extension List.IssueType: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show IssueTypes from cache.
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
