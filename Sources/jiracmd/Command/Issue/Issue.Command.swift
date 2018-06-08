//
//  Issue.Command.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core

enum Issue {
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
        case list
        case jql
    }

    enum List {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            let config = try facade.configService.loadConfig()

            guard let projectAliasName = parser.shift(), !projectAliasName.isEmpty else {
                return
            }

            let projectAlias = try facade.projectService.getAlias(name: projectAliasName)

            guard let second = parser.shift(), !second.isEmpty else {
                return
            }

            let dateRangeJQL: String
            if second == "today" {
                dateRangeJQL = "created >= startOfDay()"
            } else {
                let sprints = try facade.sprintService.fetchAllSprints(boardId: projectAlias.boardID)
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
            let issues = try facade.issueService.search(jql: jql)

            printIssues(issues, jql: jql, config: config)
        }
    }

    enum JQL {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            let config = try facade.configService.loadConfig()

            guard let first = parser.shift(), !first.isEmpty else {
                return
            }

            let jql: String
            if first == "-r" || first == "--registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    return
                }
                jql = try facade.jqlService.getAlias(name: name).jql
            } else {
                jql = first
            }

            let issues = try facade.issueService.search(jql: jql)

            printIssues(issues, jql: jql, config: config)
        }
    }

    private static func printIssues(_ issues: [Core.Issue], jql: String, config: Config) {
        print("JQL: \(jql)")

        issues.forEach { issues in
            print("\nSummary: \(issues.fields.summary)")
            print("URL: https://\(config.domain).atlassian.net/browse/\(issues.key)")
        }
    }
}
