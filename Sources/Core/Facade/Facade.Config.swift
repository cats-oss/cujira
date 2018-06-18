//
//  Facade.Config.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public enum ConfigFacadeTrait: FacadeTrait {}

extension Facade {
    public var config: FacadeExtension<ConfigFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == ConfigFacadeTrait {
    /// Set tempConfig with Dictionary.
    public func setTempConfig(withEnvironment dictionary: [String: String]) {
        base.configService.setTempConfig(dictionay: dictionary)
    }

    public func current(unsafe: Bool) throws -> Config {
        return try base.configService.loadConfig(unsafe: unsafe)
    }

    /// Update cached value of `domain`.
    public func update(domain: String) throws {
        try base.configService.update(domain: domain)
    }

    /// Update cached value of `apiKey`.
    public func update(apiKey: String) throws {
        try base.configService.update(apiKey: apiKey)
    }

    /// Update cached value of `username`.
    public func update(username: String) throws {
        try base.configService.update(username: username)
    }
}
