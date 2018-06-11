//
//  Board.Command.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core

enum Board {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .list:
            try List.run(parser)
        }
    }

    enum Command: String, CommandList {
        case list
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            
            let boards: [Core.Board]
            if let option = parser.shift(), option == "-f" || option == "--fetch" {
                boards = try facade.boardService.fetchAllBoards()
            } else {
                boards = try facade.boardService.getBoards()
            }

            print("Results:")
            if boards.isEmpty {
                print("\n\tEmpty")
            } else {
                let sorted = boards.sorted { $0.id < $1.id }
                sorted.forEach {
                    print("\n\tid: \($0.id)")
                    print("\tname: \($0.name)")
                    if case let .project(project) = $0.location {
                        print("\tproject - id: \(project.projectId)")
                        print("\tproject - name: \(project.name)")
                    }
                }
            }
        }
    }
}
