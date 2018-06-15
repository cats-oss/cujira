//
//  Facade.issue.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Foundation

extension Facade {
    public struct IssueExtension {
        fileprivate let base: Facade
    }

    public var issue: IssueExtension {
        return IssueExtension(base: self)
    }
}

extension Facade.IssueExtension {
    public func search(jql: String) throws -> SearchResult {
        let fields = try base.issueService.getFields()
        let customFields = fields.filter { $0.isCustomField }
        return try base.issueService.search(jql: jql, customFields: customFields)
    }

    public func issueType(name: String) throws -> IssueType {
        return try base.issueService.getIssueType(name: name)
    }

    public func status(name: String) throws -> Status {
        return try base.issueService.getStatus(name: name)
    }
}
