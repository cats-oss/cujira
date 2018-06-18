//
//  List.Board.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/18.
//

import Core
import Foundation

extension List {
    enum Board {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {

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

extension List.Board: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd)
                ... Show boards from cache.
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
