//
//  Facade.Project.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public enum ProjectFacadeTrait: FacadeTrait {}

extension Facade {
    public var project: FacadeExtension<ProjectFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == ProjectFacadeTrait {
    public func aliases() throws ->  [ProjectAlias] {
        return try base.projectService.loadAliases()
    }

    public func alias(name: String) throws -> ProjectAlias {
        return try base.projectService.getAlias(name: name)
    }

    public func addAlias(name: String, projectID: Int, boardID: Int) throws {
        try base.projectService.addAlias(name: name, projectID: projectID, boardID: boardID)
    }

    public func removeAlias(name: String) throws {
        try base.projectService.removeAlias(name: name)
    }
}
