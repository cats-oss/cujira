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
    private let epicDataManager: EpicDataManager

    private var issueTypes: [IssueType]?
    private var epics: [Epic]?
    private var statuses: [Status]?

    public init(session: JiraSession,
                issueTypeDataManager: IssueTypeDataManager,
                statusDataManager: StatusDataManager,
                epicDataManager: EpicDataManager) {
        self.session = session
        self.issueTypeDataManager = issueTypeDataManager
        self.statusDataManager = statusDataManager
        self.epicDataManager = epicDataManager
    }

    func search(jql: String, customFields: [Field], limit: Int = 500) throws -> SearchResult {
        
        func recursiveFetch(startAt: Int, list: [Issue]) throws -> [Issue] {
            let response = try session.send(SearchRequest(jql: jql,
                                                          fieldParameters: [.all, .exceptComment],
                                                          startAt: startAt,
                                                          customFields: customFields.map { $0.id }))
            let values = response.values
            let newList = list + values
            let isLast = values.isEmpty ? true : (response.total ?? 0) == newList.count
            if isLast || newList.count >= limit {
                return newList
            } else {
                return try recursiveFetch(startAt: newList.count, list: newList)
            }
        }

        let issues = try recursiveFetch(startAt: 0, list: [])
        return SearchResult(issues: issues, customFields: customFields)
    }

    // MRAK: - IssueType

    func fetchAllIssueTypes() throws -> [IssueType] {
        let request = GetAllIssueTypesRequest()
        let types = try session.send(request)
        self.issueTypes = types

        try issueTypeDataManager.saveIssueTypes(types)



        return types
    }

    func getIssueTypes(shouldFetchIfError: Bool) throws -> [IssueType] {
        if let types = issueTypes {
            return types
        }

        do {
            let types = try issueTypeDataManager.loadIssueTypes()
            self.issueTypes = types
            return types
        } catch IssueTypeTrait.Error.noIssueTypes {
            if shouldFetchIfError {
                return try fetchAllIssueTypes()
            } else {
                return []
            }
        } catch {
            throw error
        }
    }

    func getIssueType(name: String, useCache: Bool) throws -> IssueType {
        if useCache {
            let types = try getIssueTypes(shouldFetchIfError: false)
            return try types.first { $0.name == name } ??
                getIssueType(name: name, useCache: false)
        } else {
            let types = try fetchAllIssueTypes()
            return try types.first { $0.name == name } ?? {
                throw IssueTypeTrait.Error.noIssueType(name)
            }()
        }
    }

    func getIssueTypes(name: String, useCache: Bool) throws -> [IssueType] {
        if useCache {
            let types = try getIssueTypes(shouldFetchIfError: false)
            let filteredTypes = types.filter { $0.name == name }
            if filteredTypes.isEmpty {
                return try getIssueTypes(name: name, useCache: false)
            } else {
                return filteredTypes
            }
        } else {
            let types = try fetchAllIssueTypes()
            return types.filter { $0.name == name }
        }
    }

    // MARK: - Status

    func fetchAllStatuses() throws -> [Status] {
        let request = GetAllStatusesRequest()
        let statues = try session.send(request)
        self.statuses = statues

        try statusDataManager.saveStatuses(statues)

        return statues
    }

    func getStatuses(shouldFetchIfError: Bool) throws -> [Status] {
        if let statuses = self.statuses {
            return statuses
        }

        do {
            let statuses = try statusDataManager.loadStatuses()
            self.statuses = statuses
            return statuses
        } catch StatusTrait.Error.noStatuses {
            if shouldFetchIfError {
                return try fetchAllStatuses()
            } else {
                return []
            }
        } catch {
            throw error
        }
    }

    func getStatus(name: String, useCache: Bool) throws -> Status {
        if useCache {
            let statuses = try getStatuses(shouldFetchIfError: false)
            return try statuses.first { $0.name == name } ??
                getStatus(name: name, useCache: false)
        } else {
            let statuses = try fetchAllStatuses()
            return try statuses.first { $0.name == name } ?? {
                throw StatusTrait.Error.noStatus(name)
            }()
        }
    }

    // MARK: - Epic

    func fetchAllEpics(boardID: Int, limit: Int = 1000) throws -> [Epic] {

        func recursiveFetch(startAt: Int, list: [Epic]) throws -> [Epic] {
            let response = try session.send(GetEpicRequest(boardID: boardID, startAt: startAt))
            let values = response.values
            let newList = list + values
            let isLast = values.isEmpty ? true : (response.total ?? 0) == newList.count
            if isLast || newList.count >= limit {
                return newList
            } else {
                return try recursiveFetch(startAt: newList.count, list: newList)
            }
        }

        let epics = try recursiveFetch(startAt: 0, list: [])
        self.epics = epics

        try epicDataManager.saveEpics(epics, boardID: boardID)

        return epics
    }

    func getEpics(boardID: Int, shouldFetchIfError: Bool) throws -> [Epic] {
        if let epics = self.epics {
            return epics
        }

        do {
            let epics = try epicDataManager.loadEpics(boardID: boardID)
            self.epics = epics
            return epics
        } catch EpicTrait.Error.noEpicsFromBoardID {
            if shouldFetchIfError {
                return try fetchAllEpics(boardID: boardID)
            } else {
                return []
            }
        } catch {
            throw error
        }
    }

    func getEpic(key: String, boardID: Int, useCache: Bool) throws -> Epic {
        if useCache {
            let epics = try getEpics(boardID: boardID, shouldFetchIfError: false)
            return try epics.first { $0.key == key } ??
                getEpic(key: key, boardID: boardID, useCache: false)
        } else {
            let epics = try fetchAllEpics(boardID: boardID)
            return try epics.first { $0.key == key } ?? {
                throw EpicTrait.Error.noEpic(key)
            }()
        }
    }
}
