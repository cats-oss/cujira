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
    public struct Fields {
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
        public let customFields: [CustomField]
    }
}

extension Issue.Fields: Codable {
    static let customFieldsKey = CodingUserInfoKey(rawValue: "issue-fields-customFields")!

    private enum CodingKeys: String, CodingKey {
        case summary
        case assignee
        case created
        case updated
        case creator
        case reporter
        case status
        case labels
        case issuetype
        case project
        case fixVersions
        case customFields
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.summary = try container.decode(String.self, forKey: .summary)
        self.assignee = try container.decodeIfPresent(User.self, forKey: .assignee)
        self.created = try container.decode(Date.self, forKey: .created)
        self.updated = try container.decode(Date.self, forKey: .updated)
        self.creator = try container.decode(User.self, forKey: .creator)
        self.reporter = try container.decode(User.self, forKey: .reporter)
        self.status = try container.decode(Status.self, forKey: .status)
        self.labels = try container.decode([String].self, forKey: .labels)
        self.issuetype = try container.decode(IssueType.self, forKey: .issuetype)
        self.project = try container.decode(Project.self, forKey: .project)
        self.fixVersions = try container.decode([Version].self, forKey: .fixVersions)

        if let customFields = decoder.userInfo[Issue.Fields.customFieldsKey] as? [String] {
            self.customFields = try customFields.compactMap {
                let container = try decoder.container(keyedBy: AnyCodingKey.self)
                let key = AnyCodingKey(stringValue: $0)

                if let value = try? container.decode(String.self, forKey: key) {
                    return CustomField(id: $0, value: value)
                } else if let value = try? container.decode(Int.self, forKey: key) {
                    return CustomField(id: $0, value: value)
                } else if let value = try? container.decode(Bool.self, forKey: key) {
                    return CustomField(id: $0, value: value)
                } else {
                    return nil
                }
            }
        } else {
            self.customFields = []
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(summary, forKey: .summary)
        try container.encode(assignee, forKey: .assignee)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
        try container.encode(creator, forKey: .creator)
        try container.encode(reporter, forKey: .reporter)
        try container.encode(status, forKey: .status)
        try container.encode(labels, forKey: .labels)
        try container.encode(issuetype, forKey: .issuetype)
        try container.encode(project, forKey: .project)
        try container.encode(fixVersions, forKey: .fixVersions)
        try container.encode(customFields, forKey: .customFields)
    }
}

extension Issue.Fields {
    public struct CustomField {
        public let id: String
        public let value: Any
    }
}

extension Issue.Fields.CustomField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        do {
            if let value = try container.decodeIfPresent(String.self, forKey: .value) {
                self.value = value
            } else if let value = try container.decodeIfPresent(Int.self, forKey: .value) {
                self.value = value
            } else {
                self.value = try container.decode(Bool.self, forKey: .value)
            }
        } catch {
            throw error
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let string = value as? String {
            try container.encode(string, forKey: .value)
        } else if let int = value as? Int {
            try container.encode(int, forKey: .value)
        } else if let bool = value as? Bool {
            try container.encode(bool, forKey: .value)
        } else {
            throw EncodingError.invalidValue(value, .init(codingPath: [CodingKeys.value], debugDescription: "Failed to cast"))
        }
    }
}
