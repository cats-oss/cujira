//
//  ProjectAlias.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

struct ProjectAlias: Codable {
    let name: String
    let projectID: Int
}

extension ProjectAlias: Equatable {
    static func == (lhs: ProjectAlias, rhs: ProjectAlias) -> Bool {
        return lhs.name == rhs.name
    }
}
