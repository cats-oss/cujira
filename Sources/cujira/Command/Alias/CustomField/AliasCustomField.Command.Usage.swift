//
//  AliasCustomField.Command.Usage.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Core

extension AliasCustomField.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .epiclink, .storypoint:
                return AliasCustomField.UpdateAlias.usageDescription(element.rawValue)
            case .list:
                return AliasCustomField.List.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(root: cmd, cmd: Alias.Command.customfield, values: values, separator: "\n")
    }
}

extension AliasCustomField.UpdateAlias: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [FIELD_ID]
                ... Add Custom Field alias with `FIELD_ID`.
        """
    }
}

extension AliasCustomField.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show all Field aliases.
        """
    }
}
