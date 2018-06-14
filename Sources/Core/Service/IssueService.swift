//
//  IssueService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class IssueService {
    private let session: JiraSession
    private let issueTypeDataManager: IssueTypeDataManager
    private let statusDataManager: StatusDataManager

    public init(session: JiraSession,
                issueTypeDataManager: IssueTypeDataManager,
                statusDataManager: StatusDataManager) {
        self.session = session
        self.issueTypeDataManager = issueTypeDataManager
        self.statusDataManager = statusDataManager
    }

    public func search(jql: String, limit: Int = 500) throws -> [Issue] {
        let feilds = try fetchAllFields()
        let customFields = feilds.filter { $0.id.hasPrefix("customfield_") }.map { $0.id }

        func recursiveFetch(startAt: Int, list: [Issue]) throws -> [Issue] {
            let response = try session.send(SearchRequest(jql: jql,
                                                          fieldParameters: [.all, .exceptComment],
                                                          startAt: startAt,
                                                          customFields: customFields))
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

    // MARK: - Status

    public func fetchAllStatuses() throws -> [Status] {
        let request = GetAllStatusesRequest()
        let statues = try session.send(request)

        try statusDataManager.saveStatuses(statues)

        return statues
    }

    public func getStatuses() throws -> [Status] {
        do {
            return try statusDataManager.loadStatuses()
        } catch StatusTrait.Error.noStatuses {
            return try fetchAllStatuses()
        } catch {
            throw error
        }
    }

    public func getStatus(name: String, useCache: Bool = true) throws -> Status {
        if useCache {
            let statuses = try getStatuses()
            return try statuses.first { $0.name == name } ??
                getStatus(name: name, useCache: false)
        } else {
            let statuses = try fetchAllStatuses()
            return try statuses.first { $0.name == name } ?? {
                throw StatusTrait.Error.noStatus(name)
            }()
        }
    }
}
