//
//  ProjectAlias.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

struct ProjectAlias: Codable {
    struct Raw: Codable {
        var name: String?
        var projectID: Int?
        var boardID: Int?
    }
    let name: String
    let projectID: Int
    let boardID: Int
}

extension ProjectAlias: Equatable {
    static func == (lhs: ProjectAlias, rhs: ProjectAlias) -> Bool {
        return lhs.name == rhs.name
    }

    func toRaw() -> Raw {
        return Raw(name: name, projectID: projectID, boardID: boardID)
    }
}
