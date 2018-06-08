//
//  Issue.Command.Usage.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Issue.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .list:
                return Issue.List.usageDescription(element.rawValue)
            case .jql:
                return Issue.JQL.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command.issue, values: values, separator: "\n\n")
    }
}

extension Issue.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [PROJECT_ALIAS] [today | SPRINT_NAME]

            Options:

                -t | --type [ISSUE_TYPE]
                -l | --label [ISSUE_LABEL]
                -j | --json
        """
    }
}

extension Issue.JQL: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) (JQL_STRING)

            Options:

                -r | --registered [JQL_ALIAS]
                -j | --json
        """
    }
}
