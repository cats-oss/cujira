//
//  SprintsCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

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
        static func run(_ parser: ArgumentParser, session: JIRASession = .init()) throws {
            guard let boardId = parser.shift().flatMap(Int.init) else {
                return
            }

            func recursiveFetch(startAt: Int, list: [Sprint]) throws -> [Sprint] {
                let response = try session.send(GetAllSprintsRequest(boardId: boardId, startAt: startAt))
                let values = response.values
                let isLast = values.isEmpty ? true : response.isLast ?? true
                let newList = list + values
                if isLast {
                    return newList
                } else {
                    return try recursiveFetch(startAt: values.count, list: newList)
                }
            }

            let sprints = try recursiveFetch(startAt: 0, list: [])

            print("Results:")
            if sprints.isEmpty {
                print("\n\tEmpty")
            } else {
                let sorted = sprints.sorted { $0.id < $1.id }
                sorted.forEach {
                    print("\n\tid: \($0.id)")
                    print("\tname: \($0.name)")
                    print("\tstartDate: \($0.startDate ?? "--")")
                    print("\tendDate: \($0.endDate ?? "--")")
                }
            }
        }
    }
}
