//
//  BoardCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

enum Boards {
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
            do {
                let boardResopnse = try session.send(GetAllBoardsRequest())
                print("Results:\n")
                if boardResopnse.values.isEmpty {
                    print("\tEmpty")
                } else {
                    let boards = boardResopnse.values.sorted { $0.id < $1.id }
                    boards.forEach {
                        print("\tid: \($0.id), name: \($0.name)")
                    }
                }
            } catch let e {
                throw e
            }
        }
    }
}
