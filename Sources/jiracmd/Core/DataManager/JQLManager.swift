//
//  JQLManager.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

typealias JQLManager = DataManager<JQLTrait>

enum JQLTrait: DataTrait {
    typealias RawObject = JQLEntityList
    static let filename = "jql_list"

    enum Error: Swift.Error {
        case noJQLs
        case nameExists(String)
        case nameNotFound(String)
    }
}

extension DataManager where Trait == JQLTrait {
    static let shared = JQLManager()

    func loadJQLs() throws -> [JQLEntity] {
        let jqlList = try getRawModel() ?? {
            throw Trait.Error.noJQLs
        }()

        if jqlList.jqls.isEmpty {
            throw Trait.Error.noJQLs
        }

        return jqlList.jqls
    }

    func showJQLs() throws {
        let jqls = try loadJQLs()
        print("Registered JIRA Query Language List:\n")
        jqls.forEach {
            print("\tname: \($0.name), jql: \($0.jql)")
        }
    }

    func getJQL(name: String) throws -> JQLEntity {
        let jqls = try loadJQLs()
        guard let index = jqls.index(where: { $0.name == name }) else {
            throw Trait.Error.nameNotFound(name)
        }
        return jqls[index]
    }

    func addJQL(name: String, jql: String) throws {
        let entity = JQLEntity(name: name, jql: jql)
        var list = try getRawModel() ?? JQLEntityList(jqls: [])
        if list.jqls.contains(entity) {
            throw Trait.Error.nameExists(name)
        }
        list.jqls.append(entity)
        try write(list)
    }

    func removeJQL(name: String) throws {
        var jqls = try loadJQLs()
        guard let index = jqls.index(where: { $0.name == name }) else {
            throw Trait.Error.nameNotFound(name)
        }
        jqls.remove(at: index)
        try write(JQLEntityList(jqls: jqls))
    }
}
