//
//  JQLService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

final class JQLService {
    private let aliasManager: JQLAliasManager

    init(aliasManager: JQLAliasManager) {
        self.aliasManager = aliasManager
    }

    func loadAliases() throws -> [JQLAlias] {
        return try aliasManager.loadAliases()
    }

    func getAlias(name: String) throws -> JQLAlias {
        return try aliasManager.getAlias(name: name)
    }

    func addAlias(name: String, jql: String) throws {
        return try aliasManager.addAlias(name: name, jql: jql)
    }

    func removeAlias(name: String) throws {
        try aliasManager.removeAlias(name: name)
    }
}
