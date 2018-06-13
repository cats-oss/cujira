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
                return "\t+ \(element.rawValue) ... Register `domain`, `apikey` and `username`. In addition, manage them."
            case .issue:
                return "\t+ \(element.rawValue) ... Get issues from API or Cache."
            case .board:
                return "\t+ \(element.rawValue) ... Get boards from API or Cache."
            case .sprint:
                return "\t+ \(element.rawValue) ... Get sprints from API or Cache."
            case .alias:
                return "\t+ \(element.rawValue) ... Manage aliases."
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command?.none, values: values, separator: "\n")
    }
}
