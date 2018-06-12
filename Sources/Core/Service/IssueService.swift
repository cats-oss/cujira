//
//  IssueService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class IssueService {
    private let session: JiraSession
    private let issueTypeDataManager: IssueTypeDataManager

    public init(session: JiraSession,
                issueTypeDataManager: IssueTypeDataManager) {
        self.session = session
        self.issueTypeDataManager = issueTypeDataManager
    }

    public func search(jql: String, limit: Int = 500) throws -> [Issue] {
        func recursiveFetch(startAt: Int, list: [Issue]) throws -> [Issue] {
            let response = try session.send(SearchRequest(jql: jql, startAt: startAt))
            let values = response.values
            let newList = list + values
            let isLast = values.isEmpty ? true : (response.total ?? 0) == newList.count
            if isLast || newList.count >= limit {
                return newList
            } else {
                return try recursiveFetch(startAt: newList.count, list: newList)
            }
        }

        return try recursiveFetch(startAt: 0, list: [])
    }

    // MRAK: - IssueType

    public func fetchAllIssueTypes() throws -> [IssueType] {
        let request = GetAllIssueTypesRequest()
        let types = try session.send(request)

        try issueTypeDataManager.saveIssueTypes(types)

        return types
    }

    public func getIssueTypes() throws -> [IssueType] {
        do {
            return try issueTypeDataManager.loadIssueTypes()
        } catch IssueTypeTrait.Error.noIssueTypes {
            return try fetchAllIssueTypes()
        } catch {
            throw error
        }
    }

    public func getIssueType(name: String, useCache: Bool = true) throws -> IssueType {
        if useCache {
            let types = try getIssueTypes()
            return try types.first { $0.name == name } ??
                getIssueType(name: name, useCache: false)
        } else {
            let types = try fetchAllIssueTypes()
            return try types.first { $0.name == name } ?? {
                throw IssueTypeTrait.Error.noIssueType(name)
            }()
        }
    }

    // MARK: - Field

    public func fetchAllFields() throws -> [Field] {
        let request = GetAllFieldsRequest()
        return try session.send(request)
    }
}
