//
//  Alias.ProjectCommand.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

extension Alias {
    enum Project {
        static func run(_ parser: ArgumentParser) throws {
            let command: Command = try parser.parse()
            switch command {
            case .add:
                try Add.run(parser)
            case .remove:
                try Remove.run(parser)
            case .list:
                try List.run(parser)
            }
        }

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
            static func run(_ parser: ArgumentParser, manager: ProjectAliasManager = .shared) throws {
                guard let name = parser.shift(), !name.isEmpty else {
                    return
                }

                guard let projectID = parser.shift().flatMap(Int.init) else {
                    return
                }

                guard let boardID = parser.shift().flatMap(Int.init) else {
                    return
                }

                try manager.addAlias(name: name, projectID: projectID, boardID: boardID)
            }
        }

        enum Remove {
            static func run(_ parser: ArgumentParser, manager: ProjectAliasManager = .shared) throws {
                guard let name = parser.shift(), !name.isEmpty else {
                    return
                }

                try manager.removeAlias(name: name)
            }
        }

        enum List {
            static func run(_ parser: ArgumentParser, manager: ProjectAliasManager = .shared) throws {
                try manager.showAliases()
            }
        }
    }

}
