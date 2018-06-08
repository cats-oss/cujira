//
//  AliasProject.Command.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

import Core

enum AliasProject {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .add:
            try Add.run(parser)
        case .remove:
            try Remove.run(parser)
        case .list:
            try List.run(parser)
        }
    }

    enum Command: String, CommandList {
        case add
        case remove
        case list
    }

    enum Add {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                return
            }

            guard let projectID = parser.shift().flatMap(Int.init) else {
                return
            }

            guard let boardID = parser.shift().flatMap(Int.init) else {
                return
            }

            try facade.projectService.addAlias(name: name, projectID: projectID, boardID: boardID)
        }
    }

    enum Remove {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                return
            }

            try facade.projectService.removeAlias(name: name)
        }
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            let aliases = try facade.projectService.loadAliases()

            print("Registered Project Aliases:\n")
            aliases.forEach {
                print("\tname: \($0.name), projectID: \($0.projectID), boardID: \($0.boardID)")
            }
        }
    }
}
