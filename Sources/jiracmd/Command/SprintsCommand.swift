//
//  SprintsCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core

enum Sprints {
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
            guard let boardId = parser.shift().flatMap(Int.init) else {
                return
            }

            let sprints = try facade.sprintService.fetchAllSprints(boardId: boardId)

            print("Results:")
            if sprints.isEmpty {
                print("\n\tEmpty")
            } else {
                let dateFormatter = Utils.yyyyMMddDateFormatter()
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
