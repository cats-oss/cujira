//
//  Issue.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

public struct Issue: Codable {
    public let id: String
    public let key: String
    public let fields: Fields
}

extension Issue: ListableResponse {
    public static let key = "issues"
}

extension Issue {
    public struct Fields: Codable {
        public let summary: String
    }
}
