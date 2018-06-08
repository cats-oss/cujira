//
//  Sprint.Command.Usage.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Sprint.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .all:
                return Sprint.All.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command.sprint, values: values, separator: "\n\n")
    }
}

extension Sprint.All: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [BOARD_ID]
        """
    }
}
