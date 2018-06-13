//
//  Sprint.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Sprint.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .list:
                return Sprint.List.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command.sprint, values: values, separator: "\n\n")
    }
}

extension Sprint.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [BOARD_ID]
                ... Show sprints from cache with a BoardID. Please check BoardIDs with `cujira board list`.
            + \(cmd) [-r | --registered] [PROJECT_ALIAS]
                ... Show sprints from cache with a registered `PROJECT_ALIAS`. Please check aliases with `cujira alias project list`.

            Options:

                -f | --fetch
                    ... fetching from API.
        """
    }
}
