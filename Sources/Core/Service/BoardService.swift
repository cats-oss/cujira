//
//  BoardService.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class BoardService {
    private let session: JiraSession
    private let boardDataManager: BoardDataManager

    public init(session: JiraSession,
                boardDataManager: BoardDataManager) {
        self.session = session
        self.boardDataManager = boardDataManager
    }

    /// Fetch all boards recursively.
    public func fetchAllBoards() throws -> [Board] {
        func recursiveFetch(startAt: Int, list: [Board]) throws -> [Board] {
            let response = try session.send(GetAllBoardsRequest(startAt: startAt))
            let values = response.values
            let isLast = values.isEmpty ? true : response.isLast ?? true
            let newList = list + values
            if isLast {
                return newList
            } else {
                return try recursiveFetch(startAt: newList.count, list: newList)
            }
        }

        let boards = try recursiveFetch(startAt: 0, list: [])

        try boardDataManager.saveBoards(boards)

        return boards
    }

    /// Get all boards.
    ///
    /// - note: First, trying to get all boards from cache.
    ///         When there are no boards, trying to fetch all boards from API.
    public func getBoards() throws -> [Board] {
        do {
            return try boardDataManager.loadBoards()
        } catch BoardTrait.Error.noBoards {
            return try fetchAllBoards()
        } catch {
            throw error
        }
    }

    private func getBoard(where: (Board) throws -> Bool, useCache: Bool) throws -> Board? {
        if useCache {
            let boards = try getBoards()
            return try boards.first(where: `where`) ??
                getBoard(where: `where`, useCache: false)
        } else {
            let boards = try fetchAllBoards()
            return try boards.first(where: `where`)
        }
    }

    /// Get a board with `boardID`.
    public func getBoard(boardID: Int, useCache: Bool) throws -> Board {
        return try getBoard(where: { $0.id == boardID }, useCache: useCache) ?? {
            throw BoardTrait.Error.noBoardFromBoardID(boardID)
        }()
    }

    /// Get a board with `projectID`.
    public func getBoard(projectID: Int, useCache: Bool) throws -> Board {
        return try getBoard(where: { $0.location.project?.projectId == projectID },
                            useCache: useCache) ?? {
            throw BoardTrait.Error.noBoardFromProjectID(projectID)
        }()
    }
}
