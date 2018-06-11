//
//  BoardService.swift
//  jiracmd
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

    public func getBoards() throws -> [Board] {
        do {
            return try boardDataManager.loadBoards()
        } catch BoardTrait.Error.noBoards {
            return try fetchAllBoards()
        } catch {
            throw error
        }
    }

    public func getBoard(boardID: Int) throws -> Board {
        let boards = try getBoards()
        let board = boards.first { $0.id == boardID }
        return try board ?? {
            throw BoardTrait.Error.noBoardFromBoardID(boardID)
        }()
    }

    public func getBoard(projectID: Int) throws -> Board {
        let boards = try getBoards()

        let board = boards.first {
            if case .project(let value) = $0.location {
                return value.projectId == projectID
            } else {
                return false
            }
        }

        return try board ?? {
            throw BoardTrait.Error.noBoardFromProjectID(projectID)
        }()
    }
}
