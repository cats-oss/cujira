//
//  ProjectService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class ProjectService {
    private let session: JiraSession
    private let aliasManager: ProjectAliasManager

    public init(session: JiraSession,
                aliasManager: ProjectAliasManager) {
        self.session = session
        self.aliasManager = aliasManager
    }

    func loadAliases() throws -> [ProjectAlias] {
        return try aliasManager.loadAliases()
    }

    func getAlias(name: String) throws -> ProjectAlias {
        return try aliasManager.getAlias(name: name)
    }

    func addAlias(name: String, projectID: Int, boardID: Int) throws {
        return try aliasManager.addAlias(name: name, projectID: projectID, boardID: boardID)
    }

    func removeAlias(name: String) throws {
        try aliasManager.removeAlias(name: name)
    }
}
