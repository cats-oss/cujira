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

protocol CommandList: Enumerable, UsageDescribable {
    var rawValue: String { get }
    init?(rawValue: String)
    static func usageFormatted<T: CommandList>(root: String, cmd: T?, values: [String], separator: String) -> String
}

extension CommandList {
    static func usageFormatted<T: CommandList>(root: String, cmd: T?, values: [String], separator: String) -> String {
        let cmd = cmd.map { " \($0.rawValue)" } ?? ""
        return """
        Usage:

            $ \(root)\(cmd) [COMMAND]

        Commands:

        \(values.joined(separator: separator))
        """
    }
}
