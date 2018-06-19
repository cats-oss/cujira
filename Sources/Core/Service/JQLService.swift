//
//  JQLService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class JQLService {
    private let aliasManager: JQLAliasManager

    private var aliases: [JQLAlias]?

    public init(aliasManager: JQLAliasManager) {
        self.aliasManager = aliasManager
    }

    func loadAliases() throws -> [JQLAlias] {
        if let aliases = self.aliases {
            return aliases
        }

        let aliases = try aliasManager.loadAliases()
        self.aliases = aliases
        return aliases
    }

    func getAlias(name: String) throws -> JQLAlias {
        let aliases = try loadAliases()
        return try aliases.first { $0.name == name } ?? {
            throw JQLAliasTrait.Error.nameNotFound(name)
        }()
    }

    func addAlias(name: String, jql: String) throws {
        try aliasManager.addAlias(name: name, jql: jql)
        aliases = nil
    }

    func removeAlias(name: String) throws {
        try aliasManager.removeAlias(name: name)
        aliases = nil
    }
}
