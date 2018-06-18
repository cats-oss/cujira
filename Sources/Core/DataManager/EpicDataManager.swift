//
//  EpicDataManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/14.
//

import Foundation

public typealias EpicDataManager = DataManager<EpicTrait>

public enum EpicTrait: DataTrait {
    public typealias RawObject = [Epic]
    public static let filename = "epic_data"

    public enum Error: Swift.Error {
        case noEpicsFromBoardID(Int)
        case noEpic(String)
    }
}

extension DataManager where Trait == EpicTrait {
    func loadEpics(boardID: Int) throws -> [Epic] {
        let epics = try getRawModel(extraPath: "/\(boardID)") ?? {
            throw Trait.Error.noEpicsFromBoardID(boardID)
            }()

        if epics.isEmpty {
            throw Trait.Error.noEpicsFromBoardID(boardID)
        }

        return epics
    }

    func saveEpics(_ epics: [Epic], boardID: Int) throws {
        if epics.isEmpty {
            throw Trait.Error.noEpicsFromBoardID(boardID)
        }

        try write(epics, extraPath: "/\(boardID)")
    }
}

extension EpicTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noEpicsFromBoardID(let boardID):
            return "BoardID: \(boardID) not found in epics."
        case .noEpic(let name):
            return "\'\(name)\' not found."
        }
    }
}
