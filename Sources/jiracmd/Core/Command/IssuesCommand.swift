//
//  IssuesCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

enum Issues {
    static func run(_ parser: ArgumentParser) throws {
        let command: Command = try parser.parse()
        switch command {
        case .search:
            try Search.run(parser)
        }
    }

    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .search:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }
        case search
    }

    enum Search {
        static func run(_ parser: ArgumentParser, manager: JQLManager = .shared, session: JIRASession = .init()) throws {
            guard let first = parser.shift(), !first.isEmpty else {
                return
            }

            let jql: String
            if first == "-r" || first == "--registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    return
                }
                jql = try manager.getJQL(name: name).jql
            } else {
                jql = first
            }

            do {
                let request = SearchRequest(jql: jql)
                print(try session.send(request))
            } catch let e {
                throw e
            }
        }
    }
}
