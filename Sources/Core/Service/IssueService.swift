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
    private let fieldDataManager: FieldDataManager
    private let epicDataManager: EpicDataManager

    private var issueTypes: [IssueType]?

    public init(session: JiraSession,
                issueTypeDataManager: IssueTypeDataManager,
                statusDataManager: StatusDataManager,
                fieldDataManager: FieldDataManager,
                epicDataManager: EpicDataManager) {
        self.session = session
        self.issueTypeDataManager = issueTypeDataManager
        self.statusDataManager = statusDataManager
        self.fieldDataManager = fieldDataManager
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

        try issueTypeDataManager.saveIssueTypes(types)

        issueTypes = types

        return types
    }

    func getIssueTypes(useMemoryCache: Bool = true) throws -> [IssueType] {
        if useMemoryCache, let types = issueTypes {
            return types
        }

        do {
            return try issueTypeDataManager.loadIssueTypes()
        } catch IssueTypeTrait.Error.noIssueTypes {
            return try fetchAllIssueTypes()
        } catch {
            throw error
        }
    }

    func getIssueType(name: String, useCache: Bool = true) throws -> IssueType {
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

    func fetchAllFields() throws -> [Field] {
        let request = GetAllFieldsRequest()
        let fields = try session.send(request)

        try fieldDataManager.saveFields(fields)

        return fields
    }

    func getFields() throws -> [Field] {
        do {
            return try fieldDataManager.loadFields()
        } catch FieldTrait.Error.noFields {
            return try fetchAllFields()
        } catch {
            throw error
        }
    }

    func getField(name: String, useCache: Bool = true) throws -> Field {
        if useCache {
            let fields = try getFields()
            return try fields.first { $0.name == name } ??
                getField(name: name, useCache: false)
        } else {
            let fields = try fetchAllFields()
            return try fields.first { $0.name == name } ?? {
                throw FieldTrait.Error.noField(name)
            }()
        }
    }

    // MARK: - Status

    func fetchAllStatuses() throws -> [Status] {
        let request = GetAllStatusesRequest()
        let statues = try session.send(request)

        try statusDataManager.saveStatuses(statues)

        return statues
    }

    func getStatuses() throws -> [Status] {
        do {
            return try statusDataManager.loadStatuses()
        } catch StatusTrait.Error.noStatuses {
            return try fetchAllStatuses()
        } catch {
            throw error
        }
    }

    func getStatus(name: String, useCache: Bool = true) throws -> Status {
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

        try epicDataManager.saveEpics(epics)

        return epics
    }

    func getEpics(boardID: Int) throws -> [Epic] {
        do {
            return try epicDataManager.loadEpics()
        } catch EpicTrait.Error.noEpics {
            return try fetchAllEpics(boardID: boardID)
        } catch {
            throw error
        }
    }

    func getEpic(key: String, boardID: Int, useCache: Bool = true) throws -> Epic {
        if useCache {
            let epics = try getEpics(boardID: boardID)
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
