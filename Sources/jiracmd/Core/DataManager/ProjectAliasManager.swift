//
//  ProjectAliasManager.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

import Foundation

typealias ProjectAliasManager = DataManager<ProjectAliasTrait>

enum ProjectAliasTrait: DataTrait {
    typealias RawObject = [ProjectAlias]
    static let filename = "project_aliases"

    enum Error: Swift.Error {
        case noProjectAliases
        case nameExists(String)
        case nameNotFound(String)
    }
}

extension DataManager where Trait == ProjectAliasTrait {
    static let shared = ProjectAliasManager()

    func loadAliases() throws -> [ProjectAlias] {
        let aliases = try getRawModel() ?? {
            throw Trait.Error.noProjectAliases
            }()

        if aliases.isEmpty {
            throw Trait.Error.noProjectAliases
        }

        return aliases
    }

    func showAliases() throws {
        let aliases = try loadAliases()
        print("Registered Project Aliases:\n")
        aliases.forEach {
            print("\tname: \($0.name), projectID: \($0.projectID)")
        }
    }

    func getAlias(name: String) throws -> ProjectAlias {
        let aliases = try loadAliases()
        guard let index = aliases.index(where: { $0.name == name }) else {
            throw Trait.Error.nameNotFound(name)
        }
        return aliases[index]
    }

    func addAlias(name: String, projectID: Int) throws {
        let alias = ProjectAlias(name: name, projectID: projectID)
        var aliases = try getRawModel() ?? [ProjectAlias]()
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
