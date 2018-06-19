//
//  List.Epic.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/19.
//

import Core
import Foundation

extension List {
    enum Epic {
        enum Error: Swift.Error {
            case noBoardID
            case noParameter
            case noProjectAlias
        }

        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let first = parser.shift(), !first.isEmpty else {
                throw Error.noParameter
            }

            let boardID: Int
            if first == "-r" || first == "--registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    throw Error.noProjectAlias
                }
                boardID = try facade.project.alias(name: name).boardID
            } else {
                guard let _boardID = Int(first) else {
                    throw Error.noBoardID
                }
                boardID = _boardID
            }

            let epics: [Core.Epic]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                epics = try facade.issue.epics(boardID: boardID, useCache: false)
            } else {
                epics = try facade.issue.epics(boardID: boardID, useCache: true)
            }

            print("Results:")
            if epics.isEmpty {
                print("\n\tEmpty")
            } else {
                epics.forEach {
                    print("\n\tid: \($0.id)")
                    print("\tname: \($0.name)")
                    print("\tkey: \($0.key)")
                    print("\tsummary: \($0.summary)")
                }
            }
        }
    }
}

extension List.Epic.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noBoardID:
            return "[BOARD_ID] is required parameter."
        case .noParameter:
            return "[BOARD_ID] or --registered [PROJECT_ALIAS] is required parameter."
        case .noProjectAlias:
            return "[PROJECT_ALIAS] is required paramter."
        }
    }
}

extension List.Epic: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [BOARD_ID]
                ... Show epics from cache with a `BOARD_ID`. Please check BoardIDs with `cujira list board`.
            + \(cmd) [-r | --registered] [PROJECT_ALIAS]
                ... Show epics from cache with a registered `PROJECT_ALIAS`. Please check aliases with `cujira alias project list`.
        """
    }

    static func usageDescriptionAndOptions(_ cmd: String) -> String {
        return usageDescription(cmd) + """


            Options:

                -f | --fetch
                    ... Fetch from API.
        """
    }
}
