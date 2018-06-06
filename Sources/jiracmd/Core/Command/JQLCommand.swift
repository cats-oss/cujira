//
//  JQLCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

enum JQL {
    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .add:
                    return ""
                case .remove:
                    return ""
                case .list:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }
        case add
        case remove
        case list
    }

    enum Add {
        static func run(_ parser: ArgumentParser, manager: JQLManager = .shared) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                return
            }

            guard let jql = parser.shift(), !jql.isEmpty else {
                return
            }

            do {
                try manager.addJQL(name: name, jql: jql)
            } catch let e as JQLTrait.Error {
                throw e
            } catch _ {
                return
            }
        }
    }

    enum Remove {
        static func run(_ parser: ArgumentParser, manager: JQLManager = .shared) throws {
            guard let name = parser.shift(), !name.isEmpty else {
                return
            }

            do {
                try manager.removeJQL(name: name)
            } catch let e as JQLTrait.Error {
                throw e
            } catch _ {
                return
            }
        }
    }

    enum List {
        static func run(_ parser: ArgumentParser, manager: JQLManager = .shared) throws {
            do {
                try manager.showJQLs()
            } catch let e as JQLTrait.Error {
                throw e
            } catch _ {
                return
            }
        }
    }
}
