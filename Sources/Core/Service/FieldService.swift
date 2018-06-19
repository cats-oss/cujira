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
    private var aliases: [FieldAlias]?

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
        self.fields = fields

        try fieldDataManager.saveFields(fields)

        return fields
    }

    func getFields(shouldFetchIfError: Bool) throws -> [Field] {
        if let fields = self.fields {
            return fields
        }

        do {
            let fields = try fieldDataManager.loadFields()
            self.fields = fields
            return fields
        } catch FieldTrait.Error.noFields {
            if shouldFetchIfError {
                return try fetchAllFields()
            } else {
                return []
            }
        } catch {
            throw error
        }
    }

    func getField(name: String, useCache: Bool) throws -> Field {
        if useCache {
            let fields = try getFields(shouldFetchIfError: false)
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
            let fields = try getFields(shouldFetchIfError: false)
            return try fields.first { $0.id == id } ??
                getField(id: id, useCache: false)
        } else {
            let fields = try fetchAllFields()
            return try fields.first { $0.id == id } ?? {
                throw FieldTrait.Error.noFieldID(id)
            }()
        }
    }

    // - MARK: Alias

    func addAlias(name: FieldAlias.Name, field: Field) throws {
        try customFieldAliasManager.addAlias(name: name, field: field)
        aliases = nil
    }

    func getAlias(name: FieldAlias.Name) throws -> FieldAlias {
        let aliases = try loadAliases()
        return try aliases.first { $0.name == name } ?? {
            throw CustomFieldAliasTrait.Error.nameNotFound(name.rawValue)
        }()
    }

    func loadAliases() throws -> [FieldAlias] {
        if let aliases = self.aliases {
            return aliases
        }

        let aliases = try customFieldAliasManager.loadAliases()
        self.aliases = aliases
        return aliases
    }
}
