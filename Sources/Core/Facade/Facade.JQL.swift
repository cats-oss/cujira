//
//  Facade.JQL.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public enum JQLFacadeTrait: FacadeTrait {}

extension Facade {
    public var jql: FacadeExtension<JQLFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == JQLFacadeTrait {
    public func aliases() throws ->  [JQLAlias] {
        return try base.jqlService.loadAliases()
    }

    public func alias(name: String) throws -> JQLAlias {
        return try base.jqlService.getAlias(name: name)
    }

    public func addAlias(name: String, jql: String) throws {
        try base.jqlService.addAlias(name: name, jql: jql)
    }

    public func removeAlias(name: String) throws {
        try base.jqlService.removeAlias(name: name)
    }
}
