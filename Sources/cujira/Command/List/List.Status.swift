//
//  List.Status.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/19.
//

import Core
import Foundation

extension List {
    enum Status {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let statuses: [Core.Status]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                statuses = try facade.issue.statuses(useCache: false)
            } else {
                statuses = try facade.issue.statuses(useCache: true)
            }

            print("Results:")
            if statuses.isEmpty {
                print("\n\tEmpty")
            } else {
                statuses.forEach { status in
                    print("""

                        id: \(status.id)
                        name: \(status.name)
                    """)
                }
            }
        }
    }
}

extension List.Status: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show Statuses from cache.
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
