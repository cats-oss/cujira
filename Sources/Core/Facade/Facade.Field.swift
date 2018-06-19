//
//  Facade.Field.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public enum FieldFacadeTrait: FacadeTrait {}

extension Facade {
    public var field: FacadeExtension<FieldFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == FieldFacadeTrait {
    public func fields(useCache: Bool) throws -> [Field] {
        if useCache {
            return try base.fieldService.getFields(shouldFetchIfError: true)
        } else {
            return try base.fieldService.fetchAllFields()
        }
    }

    public func field(id: String, useCache: Bool) throws -> Field {
        return try base.fieldService.getField(id: id, useCache: useCache)
    }

    public func addAlias(name: FieldAlias.Name, withFieldID id: String) throws {
        let field = try self.field(id: id, useCache: true)
        try base.fieldService.addAlias(name: name, field: field)
    }

    public func alias(name: FieldAlias.Name) throws -> FieldAlias {
        return try base.fieldService.getAlias(name: name)
    }

    public func aliases() throws -> [FieldAlias] {
        return try base.fieldService.loadAliases()
    }
}
