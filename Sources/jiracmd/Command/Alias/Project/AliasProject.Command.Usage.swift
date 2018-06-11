//
//  AliasProject.Command.Usage.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension AliasProject.Command {
    static func usageDescription(_ cmd: String) -> String {
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

        return usageFormatted(root: cmd, cmd: Alias.Command.project, values: values, separator: "\n")
    }
}

extension AliasProject.Add: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [NAME] [-p | --project-id] [PROJECT_ID]
            + \(cmd) [NAME] [-b | --board-id] [BOARD_ID]
        """
    }
}

extension AliasProject.Remove: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [NAME]
        """
    }
}

extension AliasProject.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
        """
    }
}
