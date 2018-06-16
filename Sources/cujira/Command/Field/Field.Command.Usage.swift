//
//  Field.Command.Usage.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Foundation

extension Field.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .list:
                return Field.List.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command.sprint, values: values, separator: "\n\n")
    }
}

extension Field.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show fields from cache.

            Options:

                -f | --fetch
                    ... fetching from API.
        """
    }
}
