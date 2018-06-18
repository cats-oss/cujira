//
//  Facade.Issue.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Foundation

public enum IssueFacadeTrait: FacadeTrait {}

extension Facade {
    public var issue: FacadeExtension<IssueFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == IssueFacadeTrait {
    public func search(jql: String) throws -> [IssueResult] {
        let fields = try base.fieldService.getFields()
        let customFields = fields.filter { $0.custom }
        let result = try base.issueService.search(jql: jql, customFields: customFields)

        let epicLink = (try? base.fieldService.getAlias(name: .epiclink))?.field.id ?? ""
        let storyPoint = (try? base.fieldService.getAlias(name: .storypoint))?.field.id ?? ""

        let issueResults = try result.issues.map { issue -> IssueResult in
            guard let projectID = Int(issue.fields.project.id) else {
                return IssueResult(issue: issue, epic: nil, storyPoint: nil)
            }

            let board = try base.boardService.getBoard(projectID: projectID, useCache: true)

            let epicAndStoryPoint = try issue.fields.customFields
                .reduce((epic: nil, storyPoint: nil)) { values, cf -> (Epic?, Int?) in
                    if let field = result.customFields.first(where: { $0.id == cf.id }) {
                        if field.id == epicLink, let key = cf.value as? String {
                            return (try base.issueService.getEpic(key: key, boardID: board.id), values.1)
                        } else if field.id == storyPoint, let storyPoint = cf.value as? Int {
                            return (values.0, storyPoint)
                        }
                    }
                    return values
                }

            return IssueResult(issue: issue, epic: epicAndStoryPoint.0, storyPoint: epicAndStoryPoint.1)
        }

        return issueResults
    }
}

// MARK: - IssueType

extension FacadeExtension where Trait == IssueFacadeTrait {
    public func issueType(name: String, useCache: Bool = true) throws -> IssueType {
        return try base.issueService.getIssueType(name: name, useCache: useCache)
    }
}

// MARK: - 

extension FacadeExtension where Trait == IssueFacadeTrait {
    public func status(name: String, useCache: Bool = true) throws -> Status {
        return try base.issueService.getStatus(name: name, useCache: useCache)
    }
}
