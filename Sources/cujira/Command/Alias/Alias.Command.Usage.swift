//
//  Alias.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Alias.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .project:
                return AliasProject.usageDescription(element.rawValue)
            case .jql:
                return AliasJQL.usageDescription(element.rawValue)
            case .customfield:
                return AliasCustomField.usageDescription(element.rawValue)
            }
        }
        return usageFormatted(root: cmd, cmd: Root.Command.alias, values: values, separator: "\n")
    }
}

extension AliasProject: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Manage project aliases.
        """
    }
}

extension AliasJQL: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Manage JQL aliases.
        """
    }
}

extension AliasCustomField: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Manage CustomField aliases.
        """
    }
}
