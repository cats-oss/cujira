//
//  FieldService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public final class FieldService {
    private let session: JiraSession
    private let fieldDataManager: FieldDataManager
    private let customFieldAliasManager: CustomFieldAliasManager

    private var fields: [Field]?

    init(session: JiraSession,
         fieldDataManager: FieldDataManager,
         customFieldAliasManager: CustomFieldAliasManager) {
        self.session = session
        self.fieldDataManager = fieldDataManager
        self.customFieldAliasManager = customFieldAliasManager
    }

    func fetchAllFields() throws -> [Field] {
        let request = GetAllFieldsRequest()
        let fields = try session.send(request)

        try fieldDataManager.saveFields(fields)

        self.fields = fields

        return fields
    }

    func getFields(useMemoryCache: Bool) throws -> [Field] {
        if useMemoryCache, let fields = fields {
            return fields
        }

        do {
            return try fieldDataManager.loadFields()
        } catch FieldTrait.Error.noFields {
            return try fetchAllFields()
        } catch {
            throw error
        }
    }

    func getField(name: String, useCache: Bool) throws -> Field {
        if useCache {
            let fields = try getFields(useMemoryCache: true)
            return try fields.first { $0.name == name } ??
                getField(name: name, useCache: false)
        } else {
            let fields = try fetchAllFields()
            return try fields.first { $0.name == name } ?? {
                throw FieldTrait.Error.noFieldName(name)
            }()
        }
    }

    func getField(id: String, useCache: Bool) throws -> Field {
        if useCache {
            let fields = try getFields(useMemoryCache: true)
            return try fields.first { $0.id == id } ??
                getField(id: id, useCache: false)
        } else {
            let fields = try fetchAllFields()
            return try fields.first { $0.id == id } ?? {
                throw FieldTrait.Error.noFieldID(id)
            }()
        }
    }

    func addAlias(name: FieldAlias.Name, field: Field) throws {
        try customFieldAliasManager.addAlias(name: name, field: field)
    }

    func getAlias(name: FieldAlias.Name) throws -> FieldAlias {
        return try customFieldAliasManager.getAlias(name: name)
    }

    func loadAliases() throws -> [FieldAlias] {
        return try customFieldAliasManager.loadAliases()
    }
}
