//
//  Issue.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

struct Issue: Codable {
    let id: String
    let key: String
    let fields: Fields
}

extension Issue: ListableResponse {
    static let key = "issues"
}

extension Issue {
    struct Fields: Codable {
        let summary: String
    }
}
