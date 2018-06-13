//
//  Register.Command.Usage.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Core

extension Register.Command {
    static func usageDescription(_ cmd: String) -> String {
        let values = elements.map { element -> String in
            switch element {
            case .domain:
                return Register.Domain.usageDescription(element.rawValue)
            case .apikey:
                return Register.ApiKey.usageDescription(element.rawValue)
            case .username:
                return Register.Username.usageDescription(element.rawValue)
            case .info:
                return Register.Info.usageDescription(element.rawValue)
            }
        }

        return usageFormatted(root: cmd, cmd: Root.Command.register, values: values, separator: "\n")
    }
}

extension Register.Domain: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [ATLASSIAN_DOMAIN]
        """
    }
}

extension Register.ApiKey: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [API_KEY]
        """
    }
}

extension Register.Username: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [USER_NAME]
        """
    }
}

extension Register.Info: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
        """
    }
}
