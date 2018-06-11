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
}
