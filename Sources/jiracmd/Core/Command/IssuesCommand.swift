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
                    return """
                    \t$ jiracmd issues list [project_alias] [today | sprint_name]
                    \n\tOptions:
                    \t\t-t | --type [issue_type]
                    \t\t-l | --label [issue_label]
                    """
                case .jql:
                    return """
                    \t$ jiracmd issues jql (jql_string)
                    \n\tOptions:
                    \t\t-r | --registered [jql_alias]
                    """
                }
            }
            return "Usage:\n\(values.joined(separator: "\n\n"))"
        }
        case list
        case jql
    }

    enum List {
        static func run(_ parser: ArgumentParser,
                        configManager: ConfigManager = .shared,
                        projectmanager: ProjectAliasManager = .shared,
                        session: JiraSession = .init()) throws {
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

            try search(jql: jql, session: session, config: config)
        }
    }

    enum JQL {
        static func run(_ parser: ArgumentParser,
                        configManager: ConfigManager = .shared,
                        manager: JQLAliasManager = .shared,
                        session: JiraSession = .init()) throws {
            let config = try configManager.loadConfig()

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

            try search(jql: jql, session: session, config: config)
        }
    }

    private static func search(jql: String, session: JiraSession, config: Config) throws {
        print("JQL: \(jql)")

        let request = SearchRequest(jql: jql)
        let issues = try session.send(request).values

        issues.forEach { issues in
            print("\nSummary: \(issues.fields.summary)")
            print("URL: https://\(config.domain).atlassian.net/browse/\(issues.key)")
        }
    }
}
