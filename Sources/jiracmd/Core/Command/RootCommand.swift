//
//  RootCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum Root {
    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .register:
                    return ""
                case .search:
                    return ""
                case .jql:
                    return ""
                }
            }
            return "Usage:\n"
        }

        case register
        case search
        case jql
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
            } catch let e as JQLTrait.Error {
                throw e
            } catch _ {
                return
            }
        }
    }
}
