//
//  JQLAlias.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

public struct JQLAlias: Codable {
    public let name: String
    public let jql: String
}

extension JQLAlias: Equatable {
    public static func == (lhs: JQLAlias, rhs: JQLAlias) -> Bool {
        return lhs.name == rhs.name
    }
}
