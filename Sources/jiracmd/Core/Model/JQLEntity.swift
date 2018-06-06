//
//  JQLEntity.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

struct JQLEntityList: Codable {
    var jqls: [JQLEntity]
}

struct JQLEntity: Codable {
    let name: String
    let jql: String
}

extension JQLEntity: Equatable {
    static func == (lhs: JQLEntity, rhs: JQLEntity) -> Bool {
        return lhs.name == rhs.name
    }
}
