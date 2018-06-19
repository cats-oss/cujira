//
//  Facade.Sprint.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public enum SprintFacadeTrait: FacadeTrait {}

extension Facade {
    public var sprint: FacadeExtension<SprintFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == SprintFacadeTrait {
    public func sprints(boardID: Int, useCache: Bool) throws -> [Sprint] {
        if useCache {
            return try base.sprintService.getSprints(boardID: boardID, shouldFetchIfError: true)
        } else {
            return try base.sprintService.fetchAllSprints(boardID: boardID)
        }
    }

    public func sprint(boardID: Int, name: String, useCache: Bool) throws -> Sprint {
        return try base.sprintService.getSprint(boardID: boardID, name: name, useCache: useCache)
    }
}
