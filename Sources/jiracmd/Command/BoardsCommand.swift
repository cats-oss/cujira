//
//  BoardsCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

enum Boards {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .all:
            try All.run(parser)
        }
    }

    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .all:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }
        case all
    }

    enum All {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            let boards = try facade.boardService.fetchAllBoards()

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
