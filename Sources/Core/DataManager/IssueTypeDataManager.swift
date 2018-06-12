//
//  IssueTypeDataManager.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public typealias IssueTypeDataManager = DataManager<IssueTypeTrait>

public enum IssueTypeTrait: DataTrait {
    public typealias RawObject = [IssueType]
    public static let filename = "issue_type_data"
    public static let path = DataManagerConst.domainRelationalPath

    public enum Error: Swift.Error {
        case noIssueTypes
        case noIssueType(String)
    }
}

extension DataManager where Trait == IssueTypeTrait {
    static let shared = IssueTypeDataManager()

    func loadIssueTypes() throws -> [IssueType] {
        let issueTypes = try getRawModel() ?? {
            throw Trait.Error.noIssueTypes
        }()

        if issueTypes.isEmpty {
            throw Trait.Error.noIssueTypes
        }

        return issueTypes
    }

    func saveIssueTypes(_ issueTypes: [IssueType]) throws {
        if issueTypes.isEmpty {
            throw Trait.Error.noIssueTypes
        }

        try write(issueTypes)
    }
}

extension IssueTypeTrait.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noIssueTypes:
            return "IssueTypes not found."
        case .noIssueType(let name):
            return "\'\(name)\' not found."
        }
    }
}
