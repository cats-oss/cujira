//
//  RegisterCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum Register {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .domain:
            try Domain.run(parser)
        case .username:
            try Username.run(parser)
        case .apikey:
            try ApiKey.run(parser)
        case .info:
            try Info.run(parser)
        }
    }
    
    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .domain:
                    return "domain"
                case .apikey:
                    return ""
                case .username:
                    return ""
                case .info:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }

        case domain
        case apikey
        case username
        case info
    }

    enum Domain {
        static func run(_ parser: ArgumentParser, manager: ConfigManager = .shared) throws {
            guard let domain = parser.shift(), !domain.isEmpty else {
                return
            }

            try manager.update(\.domain, domain)
        }
    }

    enum ApiKey {
        static func run(_ parser: ArgumentParser, manager: ConfigManager = .shared) throws {
            guard let apiKey = parser.shift(), !apiKey.isEmpty else {
                return
            }

            try manager.update(\.apiKey, apiKey)
        }
    }

    enum Username {
        static func run(_ parser: ArgumentParser, manager: ConfigManager = .shared) throws {
            guard let username = parser.shift(), !username.isEmpty else {
                return
            }

            try manager.update(\.username, username)
        }
    }

    enum Info {
        static func run(_ parser: ArgumentParser, manager: ConfigManager = .shared) throws {
            try manager.showConfig()
        }
    }
}
