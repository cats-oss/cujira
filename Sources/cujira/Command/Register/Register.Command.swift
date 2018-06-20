//
//  Register.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Core
import Foundation

enum Register {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        do {
            switch command {
            case .domain:
                try Domain.run(parser, facade: facade)
            case .username:
                try Username.run(parser, facade: facade)
            case .apikey:
                try ApiKey.run(parser, facade: facade)
            case .info:
                try Info.run(parser, facade: facade)
            }
        } catch {
            let usage = Register.Command.usageDescription(parser.commands)
            throw Root.Error(inner: error, usage: usage)
        }
    }
    
    enum Command: String, CommandList {
        case apikey
        case domain
        case info
        case username
    }

    enum Error: Swift.Error {
        case noDomain
        case noApiKey
        case noUsername
    }

    enum Domain {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let domain = parser.shift(), !domain.isEmpty else {
                throw Error.noDomain
            }

            try facade.config.update(domain: domain)
        }
    }

    enum ApiKey {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let apiKey = parser.shift(), !apiKey.isEmpty else {
                throw Error.noApiKey
            }

            try facade.config.update(apiKey: apiKey)
        }
    }

    enum Username {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let username = parser.shift(), !username.isEmpty else {
                throw Error.noUsername
            }

            try facade.config.update(username: username)
        }
    }

    enum Info {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let config = try facade.config.current(unsafe: true)

            print("Config:\n")
            print("\tdomain: \(config.domain)")
            print("\tapiKey: \(config.apiKey)")
            print("\tusername: \(config.username)")
        }
    }
}

extension Register.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDomain:
            return "ATLASSIAN_DOMAIN is required parameter."
        case .noApiKey:
            return "API_KEY is required parameter."
        case .noUsername:
            return "USER_NAME is required parameter."
        }
    }
}
