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
        case .jql:
            try JQL.run(parser)
        }
    }

    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .search:
                    return ""
                case .jql:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }
        case search
        case jql
    }

    enum Search {
        static func run(_ parser: ArgumentParser, manager: JQLAliasManager = .shared, session: JIRASession = .init()) throws {
            guard let first = parser.shift(), !first.isEmpty else {
                return
            }

            let jql: String
            if first == "-r" || first == "--registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    return
                }
                jql = try manager.getAlias(name: name).jql
            } else {
                jql = first
            }

            let request = SearchRequest(jql: jql)
            print(try session.send(request))
        }
    }

    enum JQL {
        static func run(_ parser: ArgumentParser, manager: JQLAliasManager = .shared, session: JIRASession = .init()) throws {
            guard let first = parser.shift(), !first.isEmpty else {
                return
            }

            let jql: String
            if first == "-r" || first == "--registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    return
                }
                jql = try manager.getAlias(name: name).jql
            } else {
                jql = first
            }

            let request = SearchRequest(jql: jql)
            print(try session.send(request))
        }
    }
}
