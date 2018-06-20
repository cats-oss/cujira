//
//  AliasJQL.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension AliasJQL.Command {
    static func usageDescription(_ cmds: [String]) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .add:
                return AliasJQL.Add.usageDescription(element.rawValue)
            case .remove:
                return AliasJQL.Remove.usageDescription(element.rawValue)
            case .list:
                return AliasJQL.List.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(cmds: cmds, values: values, separator: "\n")
    }
}

extension AliasJQL.Add: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [NAME] [JQL]
                ... Add JQL alias with `JQL`.
        """
    }
}

extension AliasJQL.Remove: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [NAME]
                ... Remove JQL alias with `NAME`.
        """
    }
}

extension AliasJQL.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show all JQL aliases.
        """
    }
}
