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
            case .epiclink:
                return ""
            case .storypoint:
                return ""
            }
        }

        return usageFormatted(root: cmd, cmd: Alias.Command.customfield, values: values, separator: "\n")
    }
}

