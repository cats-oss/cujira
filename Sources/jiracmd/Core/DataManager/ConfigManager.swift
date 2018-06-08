//
//  ConfigManager.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/04.
//

import Foundation

typealias ConfigManager = DataManager<ConfigTrait>

enum ConfigTrait: DataTrait {
    typealias RawObject = Config.Raw
    static let filename = "config"

    enum Error: Swift.Error {
        case noConfig
        case noDomain
        case noApiKey
        case noUsername
    }
}

extension DataManager where Trait == ConfigTrait {
    static let shared = ConfigManager()

    func loadConfig() throws -> Config {
        let config = try getRawModel() ?? {
            throw Trait.Error.noConfig
        }()

        guard let domain = config.domain, !domain.isEmpty else {
            throw Trait.Error.noDomain
        }

        guard let apiKey = config.apiKey, !apiKey.isEmpty else {
            throw Trait.Error.noApiKey
        }

        guard let username = config.username, !username.isEmpty else {
            throw Trait.Error.noUsername
        }

        return Config(domain: domain,
                      apiKey: apiKey,
                      username: username)
    }

    func update<T>(_ keyPath: WritableKeyPath<Config.Raw, Optional<T>>, _ value: T) throws {
        var config = try getRawModel() ?? Config.Raw(domain: nil, apiKey: nil, username: nil)
        config[keyPath: keyPath] = value
        try write(config)
    }
}

extension ConfigTrait.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noApiKey:
            return ""
        case .noConfig:
            return ""
        case .noDomain:
            return ""
        case .noUsername:
            return ""
        }
    }
}
