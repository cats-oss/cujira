//
//  CustomFieldAliasManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Foundation

public typealias CustomFieldAliasManager = DataManager<CustomFieldAliasTrait>

public enum CustomFieldAliasTrait: DataTrait {
    public typealias RawObject = [FieldAlias]
    public static let filename = "custom_field_aliaes"

    public enum Error: Swift.Error {
        case noFieldAliases
        case nameNotFound(String)
    }
}

extension DataManager where Trait == CustomFieldAliasTrait {
    func loadAliases() throws -> [FieldAlias] {
        let aliases = try getRawModel() ?? {
            throw Trait.Error.noFieldAliases
        }()

        if aliases.isEmpty {
            throw Trait.Error.noFieldAliases
        }

        return aliases
    }

    func addAlias(name: FieldAlias.Name, field: Field) throws {
        let alias = FieldAlias(name: name, field: field)
        var aliases = try getRawModel() ?? [FieldAlias]()

        if let index = aliases.index(where: { $0.name == name }) {
            aliases.remove(at: index)
        }

        aliases.append(alias)
        try write(aliases)
    }
}

extension CustomFieldAliasTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noFieldAliases:
            return "Can not load Field aliases."
        case .nameNotFound(let value):
            return "\'\(value)\' not found in Field aliases."
        }
    }
}
