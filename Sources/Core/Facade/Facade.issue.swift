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
    public func search(jql: String) throws -> [IssueResult] {
        let fields = try base.issueService.getFields()
        let customFields = fields.filter { $0.custom }
        let result = try base.issueService.search(jql: jql, customFields: customFields)

        let issueResults = try result.issues.map { issue -> IssueResult in
            guard let projectID = Int(issue.fields.project.id) else {
                return IssueResult(issue: issue, epic: nil, storyPoint: nil)
            }

            let board = try base.boardService.getBoard(projectID: projectID)

            let epicAndStoryPoint = try issue.fields.customFields
                .reduce((epic: nil, storyPoint: nil)) { values, cf -> (Epic?, Int?) in
                    if let field = result.customFields.first(where: { $0.id == cf.id }) {
                        if field.id == "", let key = cf.value as? String {
                            return (try base.issueService.getEpic(key: key, boardID: board.id), values.1)
                        } else if field.id == "", let storyPoint = cf.value as? Int {
                            return (values.0, storyPoint)
                        }
                    }
                    return values
                }

            return IssueResult(issue: issue, epic: epicAndStoryPoint.0, storyPoint: epicAndStoryPoint.1)
        }

        return issueResults
    }

    public func issueType(name: String) throws -> IssueType {
        return try base.issueService.getIssueType(name: name)
    }

    public func status(name: String) throws -> Status {
        return try base.issueService.getStatus(name: name)
    }
}
