//
//  AliasProject.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/07.
//

import Core
import Foundation

enum AliasProject {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        do {
            switch command {
            case .add:
                try Add.run(parser, facade: facade)
            case .remove:
                try Remove.run(parser, facade: facade)
            case .list:
                try List.run(parser, facade: facade)
            }
        } catch {
            throw Root.Error(inner: error, usage: AliasProject.Command.usageDescription(command.rawValue))
        }
    }

    enum Command: String, CommandList {
        case add
        case remove
        case list
    }

    enum Error: Swift.Error {
        case noName
        case noProjectID
        case noBoardID
        case missingParameterAfterName
        case invalidParameter
    }

    enum Add {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                throw Error.noName
            }

            guard let second = parser.shift(), !second.isEmpty else {
                throw Error.missingParameterAfterName
            }

            let projectID: Int
            let boardID: Int
            switch second {
            case "-p", "--project-id":
                guard let _projectID = parser.shift().flatMap(Int.init) else {
                    throw Error.noBoardID
                }
                projectID = _projectID
                boardID = try facade.boardService.getBoard(projectID: _projectID).id

            case "-b", "--board-id":
                guard let _boardID = parser.shift().flatMap(Int.init) else {
                    throw Error.noBoardID
                }
                boardID = _boardID

                let board = try facade.boardService.getBoard(boardID: _boardID)
                guard let _projectID = board.location.project?.projectId else {
                    throw Error.noProjectID
                }
                projectID = _projectID

            default:
                throw Error.invalidParameter
            }

            try facade.projectService.addAlias(name: name, projectID: projectID, boardID: boardID)
        }
    }

    enum Remove {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                throw Error.noName
            }

            try facade.projectService.removeAlias(name: name)
        }
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let aliases = try facade.projectService.loadAliases()

            print("Registered Project Aliases:\n")
            aliases.forEach {
                print("\tname: \($0.name), projectID: \($0.projectID), boardID: \($0.boardID)")
            }
        }
    }
}

extension AliasProject.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noName:
            return "NAME is required parameter."
        case .noBoardID:
            return "BOARD_ID is required parameter."
        case .noProjectID:
            return "PROJECT_ID is required parameter."
        case .invalidParameter:
            return "Invalid Parameter."
        case .missingParameterAfterName:
            return "[-p | --project-id] or [-b | --board-id] are required."
        }
    }
}
