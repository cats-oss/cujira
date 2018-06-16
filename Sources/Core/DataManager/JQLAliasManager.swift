//
//  JQLAliasManager.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

public typealias JQLAliasManager = DataManager<JQLAliasTrait>

public enum JQLAliasTrait: DataTrait {
    public typealias RawObject = [JQLAlias]
    public static let filename = "jql_aliaes"

    public enum Error: Swift.Error {
        case noJQLAliases
        case nameExists(String)
        case nameNotFound(String)
    }
}

extension DataManager where Trait == JQLAliasTrait {
    func loadAliases() throws -> [JQLAlias] {
        let aliases = try getRawModel() ?? {
            throw Trait.Error.noJQLAliases
        }()

        if aliases.isEmpty {
            throw Trait.Error.noJQLAliases
        }

        return aliases
    }

    func getAlias(name: String) throws -> JQLAlias {
        let aliases = try loadAliases()
        guard let index = aliases.index(where: { $0.name == name }) else {
            throw Trait.Error.nameNotFound(name)
        }
        return aliases[index]
    }

    func addAlias(name: String, jql: String) throws {
        let alias = JQLAlias(name: name, jql: jql)
        var aliases = try getRawModel() ?? [JQLAlias]()
        if aliases.contains(alias) {
            throw Trait.Error.nameExists(name)
        }
        aliases.append(alias)
        try write(aliases)
    }

    func removeAlias(name: String) throws {
        var aliases = try loadAliases()
        guard let index = aliases.index(where: { $0.name == name }) else {
            throw Trait.Error.nameNotFound(name)
        }
        aliases.remove(at: index)
        try write(aliases)
    }
}

extension JQLAliasTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noJQLAliases:
            return "Can not load JQL aliases."
        case .nameExists(let value):
            return "\'\(value)\' is already exists."
        case .nameNotFound(let value):
            return "\'\(value)\' not found in jql aliases."
        }
    }
}
