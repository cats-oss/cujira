//
//  AliasProject.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension AliasProject.Command {
    static func usageDescription(_ cmds: [String]) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .add:
                return AliasProject.Add.usageDescription(element.rawValue)
            case .remove:
                return AliasProject.Remove.usageDescription(element.rawValue)
            case .list:
                return AliasProject.List.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(cmds: cmds, values: values, separator: "\n")
    }
}

extension AliasProject.Add: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [NAME] [-p | --project-id] [PROJECT_ID]
                ... Add project alias with `PROJECT_ID`. Please check ProjectIDs with `cujira board list`.
            + \(cmd) [NAME] [-b | --board-id] [BOARD_ID]
                ... Add project alias with `BOARD_ID`. Please check BoardIDs with `cujira board list`.
        """
    }
}

extension AliasProject.Remove: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [NAME]
                ... Remove project alias with `NAME`.
        """
    }
}

extension AliasProject.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show all project aliases.
        """
    }
}
