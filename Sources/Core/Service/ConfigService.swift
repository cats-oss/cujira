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
            if let temp = tempConfig {
                return temp
            } else {
                let temp = try manager.loadConfig()
                tempConfig = temp
                return temp
            }
        }
    }

    /// Update cached value of `domain`.
    public func update(domain: String) throws {
        try manager.update(\.domain, domain)
        tempConfig = nil
    }

    /// Update cached value of `apiKey`.
    public func update(apiKey: String) throws {
        try manager.update(\.apiKey, apiKey)
        tempConfig = nil
    }

    /// Update cached value of `username`.
    public func update(username: String) throws {
        try manager.update(\.username, username)
        tempConfig = nil
    }

    /// Set tempConfig with Dictionary.
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
