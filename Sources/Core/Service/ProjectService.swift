//
//  ProjectService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class ProjectService {
    private let aliasManager: ProjectAliasManager

    private var aliases: [ProjectAlias]?

    public init(aliasManager: ProjectAliasManager) {
        self.aliasManager = aliasManager
    }

    func loadAliases() throws -> [ProjectAlias] {
        if let aliases = self.aliases {
            return aliases
        }

        let aliases = try aliasManager.loadAliases()
        self.aliases = aliases
        return aliases
    }

    func getAlias(name: String) throws -> ProjectAlias {
        let aliases = try loadAliases()
        return try aliases.first { $0.name == name } ?? {
            throw ProjectAliasTrait.Error.nameNotFound(name)
        }()
    }

    func addAlias(name: String, projectID: Int, boardID: Int) throws {
        try aliasManager.addAlias(name: name, projectID: projectID, boardID: boardID)
        aliases = nil
    }

    func removeAlias(name: String) throws {
        try aliasManager.removeAlias(name: name)
        aliases = nil
    }
}
