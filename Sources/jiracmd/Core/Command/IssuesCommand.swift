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
        case .list:
            try List.run(parser)
        case .jql:
            try JQL.run(parser)
        }
    }

    enum Command: String, CommandList {
        static var usageDescription: String {
            let values = elements.map { element -> String in
                switch element {
                case .list:
                    return "\n\tjiracmd issues list [project_alias] [today | sprint_name] (-t | --type [issue_type]) (-l | --label [issue_label])"
                case .jql:
                    return ""
                }
            }
            return "Usage:\n\(values.joined())"
        }
        case list
        case jql
    }

    enum List {
        static func run(_ parser: ArgumentParser,
                        configManager: ConfigManager = .shared,
                        projectmanager: ProjectAliasManager = .shared,
                        session: JIRASession = .init()) throws {
            let config = try configManager.loadConfig()

            guard let projectAliasName = parser.shift(), !projectAliasName.isEmpty else {
                return
            }

            let projectAlias = try projectmanager.getAlias(name: projectAliasName)

            guard let second = parser.shift(), !second.isEmpty else {
                return
            }

            let dateRangeJQL: String
            if second == "today" {
                dateRangeJQL = "created >= startOfDay()"
            } else {
                let sprints = try Utils.fetchAllSprints(boardId: projectAlias.boardID, session: session)
                guard let sprint = sprints.first(where: { $0.name.contains(second) }) else {
                    return
                }
                dateRangeJQL = "sprint = \'\(sprint.name)\'"
            }

            func parseOption(_ parser: ArgumentParser) throws -> String {
                if let option = parser.shift(), !option.isEmpty {
                    if option == "-t" || option == "--type" {
                        guard let type = parser.shift(), !type.isEmpty else {
                            return ""
                        }
                        return " AND type = \(type)"
                    } else if option == "-l" || option == "--label" {
                        guard let label = parser.shift(), !label.isEmpty else {
                            return ""
                        }
                        return " AND labels = \'\(label)\'"
                    } else {
                        return ""
                    }
                } else {
                    return ""
                }
            }

            let option1 = try parseOption(parser)
            let option2 = try parseOption(parser)

            let jql = "project = \(projectAlias.projectID) AND \(dateRangeJQL)\(option1)\(option2)"

            print("JQL: \(jql)")

            let request = SearchRequest(jql: jql)
            let issues = try session.send(request).values

            issues.forEach { issues in
                print("\nSummary: \(issues.fields.summary)")
                print("URL: https://\(config.domain).atlassian.net/browse/\(issues.key)")
            }
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
