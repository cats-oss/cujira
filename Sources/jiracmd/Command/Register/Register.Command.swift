//
//  Register.Command.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Core

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
        case apikey
        case domain
        case info
        case username
    }

    enum Domain {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            guard let domain = parser.shift(), !domain.isEmpty else {
                return
            }

            try facade.configService.update(domain: domain)
        }
    }

    enum ApiKey {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            guard let apiKey = parser.shift(), !apiKey.isEmpty else {
                return
            }

            try facade.configService.update(apiKey: apiKey)
        }
    }

    enum Username {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            guard let username = parser.shift(), !username.isEmpty else {
                return
            }

            try facade.configService.update(username: username)
        }
    }

    enum Info {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            let config = try facade.configService.loadConfig(unsafe: true)

            print("Config:\n")
            print("\tdomain: \(config.domain)")
            print("\tapiKey: \(config.apiKey)")
            print("\tusername: \(config.username)")
        }
    }
}
