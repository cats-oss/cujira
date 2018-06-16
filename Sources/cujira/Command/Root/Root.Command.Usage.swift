//
//  Root.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Root.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .register:
                return """
                    + \(element.rawValue)
                        ... Register `domain`, `apikey` and `username`. In addition, manage them.
                """
            case .issue:
                return """
                    + \(element.rawValue)
                        ... Show issues from API or Cache.
                """
            case .board:
                return """
                    + \(element.rawValue)
                        ... Show boards from API or Cache.
                """
            case .sprint:
                return """
                    + \(element.rawValue)
                        ... Show sprints from API or Cache.
                """
            case .alias:
                return """
                    + \(element.rawValue)
                        ... Manage aliases.
                """

            case .field:
                return """
                    + \(element.rawValue)
                        ... Show fields from API or Cache.
                """
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command?.none, values: values, separator: "\n")
    }
}
