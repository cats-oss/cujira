//
//  Issue.Command.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core
import Foundation

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
        private enum Option {
            case type(String)
            case label(String)
            case json

            init?(_ parser: ArgumentParser) {
                if let option = parser.shift(), !option.isEmpty {
                    switch option {
                    case "-t", "--type":
                        if let t = parser.shift(), !t.isEmpty {
                            self = .type(t)
                            return
                        }
                    case "-l", "--label":
                        if let l = parser.shift(), !l.isEmpty {
                            self = .label(l)
                            return
                        }
                    case "-j", "--json":
                        self = .json
                        return
                    default:
                        break
                    }
                }
                return nil
            }
        }

        private static func typeJQL(from options: [Option]) -> String {
            for option in options {
                if case .type(let t) = option {
                    return " AND type = \'\(t)\'"
                }
            }
            return ""
        }

        private static func labelJQL(from options: [Option]) -> String {
            for option in options {
                if case .label(let l) = option {
                    return " AND labels = \'\(l)\'"
                }
            }
            return ""
        }

        private static func isJson(from options: [Option]) -> Bool {
            for option in options {
                if case .json = option {
                    return true
                }
            }
            return false
        }

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

            let options = (0..<3).compactMap { _ in Option(parser) }
            let typeJQL = self.typeJQL(from: options)
            let labelJQL = self.labelJQL(from: options)
            let isJson = self.isJson(from: options)

            let jql = "project = \(projectAlias.projectID) AND \(dateRangeJQL)\(typeJQL)\(labelJQL)"
            let issues = try facade.issueService.search(jql: jql)

            try printIssues(issues, jql: jql, config: config, isJson: isJson)
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

            let isJson: Bool
            if let j = parser.shift(), !j.isEmpty {
                isJson = j == "-j" ||  j == "--json"
            } else {
                isJson = false
            }

            let issues = try facade.issueService.search(jql: jql)

            try printIssues(issues, jql: jql, config: config, isJson: isJson)
        }
    }

    private static func printIssues(_ issues: [Core.Issue], jql: String, config: Config, isJson: Bool) throws {
        if isJson {
            let data = try JSONEncoder().encode(issues)
            let jsonString = String(data: data, encoding: .utf8) ?? "{}"
            print(jsonString)
        } else {
            print("JQL: \(jql)")

            issues.forEach { issues in
                print("\nSummary: \(issues.fields.summary)")
                print("URL: https://\(config.domain).atlassian.net/browse/\(issues.key)")
            }
        }
    }
}
