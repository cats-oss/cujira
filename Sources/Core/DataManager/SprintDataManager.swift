//
//  SprintDataManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/11.
//

import Foundation

public typealias SprintDataManager = DataManager<SprintTrait>

public enum SprintTrait: DataTrait {
    public typealias RawObject = [Sprint]
    public static let filename = "sprint_data"

    public enum Error: Swift.Error {
        case noSprintsFromBoardID(Int)
        case noSprint(boardID: Int, sprintID: Int)
        case noSprintName(String)
    }
}

extension DataManager where Trait == SprintTrait {
    func loadSprints(boardID: Int) throws -> [Sprint] {
        let sprints = try getRawModel(extraPath: "/\(boardID)") ?? {
            throw Trait.Error.noSprintsFromBoardID(boardID)
        }()

        if sprints.isEmpty {
            throw Trait.Error.noSprintsFromBoardID(boardID)
        }

        return sprints
    }

    func saveSprints(_ sprints: [Sprint], boardID: Int) throws {
        if sprints.isEmpty {
            throw Trait.Error.noSprintsFromBoardID(boardID)
        }

        try write(sprints, extraPath: "/\(boardID)")
    }
}

extension SprintTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noSprintsFromBoardID(let boardID):
            return "BoardID: \(boardID) not found in Sprints."
        case .noSprint(let boardID, let sprintID):
            return "BoardID: \(boardID), SprintID: \(sprintID) not found in Sprints."
        case .noSprintName(let name):
            return "Sprint Name: \(name) not founc in Sprints."
        }
    }
}
