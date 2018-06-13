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

    public enum Error: Swift.Error {
        case noBoards
        case noBoardFromProjectID(Int)
        case noBoardFromBoardID(Int)
    }
}

extension DataManager where Trait == BoardTrait {
    func loadBoards() throws -> [Board] {
        let boards = try getRawModel() ?? {
            throw Trait.Error.noBoards
        }()

        if boards.isEmpty {
            throw Trait.Error.noBoards
        }

        return boards
    }

    func saveBoards(_ boards: [Board]) throws {
        if boards.isEmpty {
            throw Trait.Error.noBoards
        }

        try write(boards)
    }
}

extension BoardTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noBoards:
            return "Boards not found."
        case .noBoardFromBoardID(let boardID):
            return "BoardID: \(boardID) not found in Boards."
        case .noBoardFromProjectID(let projectID):
            return "ProjectID: \(projectID) not found in Boards."
        }
    }
}
