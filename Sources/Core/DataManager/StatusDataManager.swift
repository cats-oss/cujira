//
//  StatusDataManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public typealias StatusDataManager = DataManager<StatusTrait>

public enum StatusTrait: DataTrait {
    public typealias RawObject = [Status]
    public static let filename = "status_data"
    public static let path = DataManagerConst.domainRelationalPath

    public enum Error: Swift.Error {
        case noStatuses
        case noStatus(String)
    }
}

extension DataManager where Trait == StatusTrait {
    static let shared = StatusDataManager()

    func loadStatuses() throws -> [Status] {
        let statuses = try getRawModel() ?? {
            throw Trait.Error.noStatuses
            }()

        if statuses.isEmpty {
            throw Trait.Error.noStatuses
        }

        return statuses
    }

    func saveStatuses(_ statuses: [Status]) throws {
        if statuses.isEmpty {
            throw Trait.Error.noStatuses
        }

        try write(statuses)
    }
}

extension StatusTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noStatuses:
            return "Statuses not found."
        case .noStatus(let name):
            return "\'\(name)\' not found."
        }
    }
}
