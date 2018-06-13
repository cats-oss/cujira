//
//  JQLService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class JQLService {
    private let aliasManager: JQLAliasManager

    public init(aliasManager: JQLAliasManager) {
        self.aliasManager = aliasManager
    }

    public func loadAliases() throws -> [JQLAlias] {
        return try aliasManager.loadAliases()
    }

    public func getAlias(name: String) throws -> JQLAlias {
        return try aliasManager.getAlias(name: name)
    }

    public func addAlias(name: String, jql: String) throws {
        return try aliasManager.addAlias(name: name, jql: jql)
    }

    public func removeAlias(name: String) throws {
        try aliasManager.removeAlias(name: name)
    }
}
