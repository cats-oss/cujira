//
//  CommandList.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/07.
//

import Core

protocol UsageDescribable {
    static func usageDescription(_ cmd: String) -> String
}

protocol CommandList: Enumerable {
    var rawValue: String { get }
    init?(rawValue: String)
    static func usageDescription(_ cmds: [String]) -> String
    static func usageFormatted(cmds: [String], values: [String], separator: String) -> String
}

extension CommandList {
    static func usageFormatted(cmds: [String], values: [String], separator: String) -> String {
        return """
        Usage:

            $ \(cmds.joined(separator: " ")) [COMMAND]

        Commands:

        \(values.joined(separator: separator))
        """
    }
}
