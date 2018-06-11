//
//  BoardDataManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/11.
//

import Foundation

public typealias BoardDataManager = DataManager<BoardTrait>

public enum BoardTrait: DataTrait {
    public typealias RawObject = [Board]
    public static let filename = "board_data"
    public static let path = DataManagerConst.domainRelationalPath

    public enum Error: Swift.Error {
        case noBoards
        case noBoardFromProjectID(Int)
        case noBoardFromBoardID(Int)
    }
}

extension DataManager where Trait == BoardTrait {
    static let shared = BoardDataManager()

    func loadBoards() throws -> [Board] {
        let boards = try getRawModel() ?? {
            throw Trait.Error.noBoards
        }()

        if boards.isEmpty {
            throw Trait.Error.noBoards
        }

        return boards
    }

    func getBoard(boardID: Int) throws -> Board {
        let boards = try loadBoards()
        let board = boards.first { $0.id == boardID }
        return try board ?? {
            throw Trait.Error.noBoardFromBoardID(boardID)
        }()
    }

    func getBoard(projectID: Int) throws -> Board {
        let boards = try loadBoards()

        let board = boards.first {
            if case .project(let value) = $0.location {
                return value.projectId == projectID
            } else {
                return false
            }
        }

        return try board ?? {
            throw Trait.Error.noBoardFromProjectID(projectID)
        }()
    }

    func saveBoards(_ boards: [Board]) throws {
        if boards.isEmpty {
            throw Trait.Error.noBoards
        }

        try write(boards)
    }
}
