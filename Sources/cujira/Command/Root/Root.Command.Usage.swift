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
                return "\t+ \(element.rawValue)"
            case .issue:
                return "\t+ \(element.rawValue)"
            case .board:
                return "\t+ \(element.rawValue)"
            case .sprint:
                return "\t+ \(element.rawValue)"
            case .alias:
                return "\t+ \(element.rawValue)"
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command?.none, values: values, separator: "\n")
    }
}
