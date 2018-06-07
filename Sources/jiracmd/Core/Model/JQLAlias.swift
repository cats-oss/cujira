//
//  JQLAlias.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

struct JQLAlias: Codable {
    let name: String
    let jql: String
}

extension JQLAlias: Equatable {
    static func == (lhs: JQLAlias, rhs: JQLAlias) -> Bool {
        return lhs.name == rhs.name
    }
}
