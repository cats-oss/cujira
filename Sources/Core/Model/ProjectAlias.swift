//
//  ProjectAlias.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

public struct ProjectAlias: Codable {
    public struct Raw: Codable {
        var name: String?
        var projectID: Int?
        var boardID: Int?
    }

    public let name: String
    public let projectID: Int
    public let boardID: Int
}

extension ProjectAlias: Equatable {
    public static func == (lhs: ProjectAlias, rhs: ProjectAlias) -> Bool {
        return lhs.name == rhs.name
    }
}

extension ProjectAlias {
    func toRaw() -> Raw {
        return Raw(name: name, projectID: projectID, boardID: boardID)
    }
}
