//
//  Facade.Board.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

public enum BoardFacadeTrait: FacadeTrait {}

extension Facade {
    public var board: FacadeExtension<BoardFacadeTrait> {
        return FacadeExtension(base: self)
    }
}

extension FacadeExtension where Trait == BoardFacadeTrait {
    public func boards(useCache: Bool) throws -> [Board] {
        if useCache {
            return try base.boardService.getBoards(shouldFetchIfError: true)
        } else {
            return try base.boardService.fetchAllBoards()
        }
    }

    /// Get a board with `boardID`.
    public func board(boardID: Int, useCache: Bool) throws -> Board {
        return try base.boardService.getBoard(boardID: boardID, useCache: useCache)
    }

    /// Get a board with `projectID`.
    public func board(projectID: Int, useCache: Bool) throws -> Board {
        return try base.boardService.getBoard(projectID: projectID, useCache: useCache)
    }
}
