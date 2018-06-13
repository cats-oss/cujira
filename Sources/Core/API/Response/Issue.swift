//
//  Issue.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

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
        public let assignee: User?
        public let created: Date
        public let updated: Date
        public let creator: User
        public let reporter: User
        public let status: Status
        public let labels: [String]
        public let issuetype: IssueType
        public let project: Project
        public let fixVersions: [Version]
    }
}
