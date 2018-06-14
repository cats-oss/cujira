//
//  FieldDataManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/14.
//

import Foundation

public typealias FieldDataManager = DataManager<FieldTrait>

public enum FieldTrait: DataTrait {
    public typealias RawObject = [Field]
    public static let filename = "field_data"

    public enum Error: Swift.Error {
        case noFields
        case noField(String)
    }
}

extension DataManager where Trait == FieldTrait {
    func loadFields() throws -> [Field] {
        let fields = try getRawModel() ?? {
            throw Trait.Error.noFields
        }()

        if fields.isEmpty {
            throw Trait.Error.noFields
        }

        return fields
    }

    func saveFields(_ fields: [Field]) throws {
        if fields.isEmpty {
            throw Trait.Error.noFields
        }

        try write(fields)
    }
}

extension FieldTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noFields:
            return "Fields not found."
        case .noField(let name):
            return "\'\(name)\' not found."
        }
    }
}
