//
//  ConfigService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class ConfigService {
    private enum Key {
        static let username = "CUJIRA_USER_NAME"
        static let apikey = "CUJIRA_API_KEY"
        static let domain = "CUJIRA_DOMAIN"
    }

    private let manager: ConfigManager

    private var tempConfig: Config?

    public init(manager: ConfigManager) {
        self.manager = manager
    }

    public func loadConfig(unsafe: Bool = false) throws -> Config {
        if unsafe {
            let config = try manager.getRawModel()
            return Config(domain: config?.domain ?? "nil",
                          apiKey: config?.apiKey ?? "nil",
                          username: config?.username ?? "nil")
        } else {
            return try tempConfig ?? manager.loadConfig()
        }
    }

    public func update(domain: String) throws {
        try manager.update(\.domain, domain)
        try manager.removeDomainRelationalDirectory()
    }

    public func update(apiKey: String) throws {
        try manager.update(\.apiKey, apiKey)
    }

    public func update(username: String) throws {
        try manager.update(\.username, username)
    }

    public func setTempConfig(dictionay: [String: String]) {
        guard
            let username = dictionay[Key.username], !username.isEmpty,
            let apikey = dictionay[Key.apikey], !apikey.isEmpty,
            let domain = dictionay[Key.domain], !domain.isEmpty
        else {
            return
        }
        tempConfig = Config(domain: domain, apiKey: apikey, username: username)
    }
}
