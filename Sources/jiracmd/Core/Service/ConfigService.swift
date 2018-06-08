//
//  ConfigService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

final class ConfigService {
    private let manager: ConfigManager

    init(manager: ConfigManager) {
        self.manager = manager
    }

    func loadConfig(unsafe: Bool = false) throws -> Config {
        if unsafe {
            let config = try manager.getRawModel()
            return Config(domain: config?.domain ?? "nil",
                          apiKey: config?.apiKey ?? "nil",
                          username: config?.username ?? "nil")
        } else {
            return try manager.loadConfig()
        }
    }

    func update(domain: String) throws {
        try manager.update(\.domain, domain)
    }

    func update(apiKey: String) throws {
        try manager.update(\.apiKey, apiKey)
    }

    func update(username: String) throws {
        try manager.update(\.username, username)
    }
}
