//
//  ConfigService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class ConfigService {
    private let manager: ConfigManager

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
            return try manager.loadConfig()
        }
    }

    public func update(domain: String) throws {
        try manager.update(\.domain, domain)
    }

    public func update(apiKey: String) throws {
        try manager.update(\.apiKey, apiKey)
    }

    public func update(username: String) throws {
        try manager.update(\.username, username)
    }
}
