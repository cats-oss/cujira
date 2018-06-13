//
//  SprintService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class SprintService {
    private let session: JiraSession
    private let sprintDataManager: SprintDataManager

    public init(session: JiraSession,
                sprintDataManager: SprintDataManager) {
        self.session = session
        self.sprintDataManager = sprintDataManager
    }

    public func fetchAllSprints(boardID: Int) throws -> [Sprint] {
        func recursiveFetch(startAt: Int, list: [Sprint]) throws -> [Sprint] {
            let response = try session.send(GetAllSprintsRequest(boardId: boardID, startAt: startAt))
            let values = response.values
            let isLast = values.isEmpty ? true : response.isLast ?? true
            let newList = list + values
            if isLast {
                return newList
            } else {
                return try recursiveFetch(startAt: newList.count, list: newList)
            }
        }

        let sprints = try recursiveFetch(startAt: 0, list: [])

        try sprintDataManager.saveSprints(sprints, boardID: boardID)

        return sprints
    }

    public func getSprints(boardID: Int) throws -> [Sprint] {
        do {
            return try sprintDataManager.loadSprints(boardID: boardID)
        } catch SprintTrait.Error.noSprintsFromBoardID {
            return try fetchAllSprints(boardID: boardID)
        } catch {
            throw error
        }
    }

    public func getSprint(sprintID: Int, boardID: Int, useCache: Bool = true) throws -> Sprint {
        if useCache {
            let sprints = try getSprints(boardID: boardID)
            return try sprints.first { $0.id == sprintID } ??
                getSprint(sprintID: sprintID, boardID: boardID, useCache: false)
        } else {
            let sprints = try fetchAllSprints(boardID: boardID)
            return try sprints.first { $0.id == sprintID } ?? {
                throw SprintTrait.Error.noSprint(boardID: boardID, sprintID: sprintID)
            }()
        }
    }
}
