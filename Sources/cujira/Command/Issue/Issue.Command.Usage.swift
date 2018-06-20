//
//  Issue.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Issue.Command {
    static func usageDescription(_ cmds: [String]) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .search:
                return Issue.Search.usageDescription(element.rawValue)
            case .jql:
                return Issue.JQL.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(cmds: cmds, values: values, separator: "\n\n")
    }
}
