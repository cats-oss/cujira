//
//  Sprint.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core
import Foundation

enum Sprint {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        do {
            switch command {
            case .list:
                try List.run(parser)
            }
        } catch {
            throw Root.Error(inner: error, usage: Sprint.Command.usageDescription(parser.root))
        }
    }

    enum Command: String, CommandList {
        case list
    }

    enum List {
        enum Error: Swift.Error {
            case noBoardID
            case noParameter
            case noProjectAlias
        }

        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            guard let first = parser.shift(), !first.isEmpty else {
                throw Error.noParameter
            }

            let boardID: Int
            if first == "-r" || first == "-registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    throw Error.noProjectAlias
                }
                boardID = try facade.projectService.getAlias(name: name).boardID
            } else {
                guard let _boardID = Int(first) else {
                    throw Error.noBoardID
                }
                boardID = _boardID
            }

            let sprints: [Core.Sprint]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                sprints = try facade.sprintService.fetchAllSprints(boardID: boardID)
            } else {
                sprints = try facade.sprintService.getSprints(boardID: boardID)
            }

            print("Results:")
            if sprints.isEmpty {
                print("\n\tEmpty")
            } else {
                let dateFormatter = DateFormatter.core.yyyyMMdd
                let sorted = sprints.sorted { $0.id < $1.id }
                sorted.forEach {
                    print("\n\tid: \($0.id)")
                    print("\tname: \($0.name)")
                    print("\tstartDate: \($0.startDate.map { dateFormatter.string(from: $0) } ?? "--")")
                    print("\tendDate: \($0.endDate.map { dateFormatter.string(from: $0) } ?? "--")")
                }
            }
        }
    }
}

extension Sprint.List.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noBoardID:
            return "BOARD_ID is required parameter."
        case .noParameter:
            return "BOARD_ID or --registered [PROJECT_ALIAS] is required parameter."
        case .noProjectAlias:
            return "PROJECT_ALIAS is required paramter."
        }
    }
}
