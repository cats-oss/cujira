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
        case noEpics
        case noEpic(String)
    }
}

extension DataManager where Trait == EpicTrait {
    func loadEpics() throws -> [Epic] {
        let epics = try getRawModel() ?? {
            throw Trait.Error.noEpics
            }()

        if epics.isEmpty {
            throw Trait.Error.noEpics
        }

        return epics
    }

    func saveEpics(_ epics: [Epic]) throws {
        if epics.isEmpty {
            throw Trait.Error.noEpics
        }

        try write(epics)
    }
}

extension EpicTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noEpics:
            return "Epics not found."
        case .noEpic(let name):
            return "\'\(name)\' not found."
        }
    }
}
