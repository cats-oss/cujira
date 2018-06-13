//
//  Issue.List.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation
import Core

extension Issue {
    enum List {
        enum Error: Swift.Error {
            case noDateRange
            case noProjectAlias
            case notFoundSprint(String)
        }

        fileprivate enum Option {
            case type(String)
            case label(String)
            case status(String)
            case user(String)
            case json
            case aggregate

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
                    case "-s", "--status":
                        if let s = parser.shift(), !s.isEmpty {
                            self = .status(s)
                            return
                        }
                    case "-u", "--user":
                        if let u = parser.shift(), !u.isEmpty {
                            self = .user(u)
                            return
                        }
                    case "--output-json":
                        self = .json
                        return

                    case "-a", "--aggregate":
                        self = .aggregate
                        return

                    default:
                        break
                    }
                }
                return nil
            }
        }

        private struct JQLContainer {
            let name: String
            let jql: String
        }

        private static func typeJQL(from options: [Option], facade: Facade) throws -> JQLContainer? {
            guard let typeName = options.lazy.compactMap({ $0.type }).first else {
                return nil
            }

            let type = try facade.issueService.getIssueType(name: typeName)
            return JQLContainer(name: typeName, jql: " AND issuetype = \(type.id)")
        }

        private static func labelJQL(from options: [Option]) -> JQLContainer? {
            return options.lazy.compactMap { $0.label }.first
                .map { JQLContainer(name: $0, jql: " AND labels = \'\($0)\'")  }
        }

        private static func statusJQL(from options: [Option], facade: Facade) throws -> JQLContainer? {
            guard let statusName = options.lazy.compactMap({ $0.status }).first else {
                return nil
            }

            let status = try facade.issueService.getStatus(name: statusName)
            return JQLContainer(name: statusName, jql: " AND status = \(status.id)")
        }

        private static func userJQL(from options: [Option]) -> JQLContainer? {
            return options.lazy.compactMap { $0.user }.first
                .map { JQLContainer(name: $0, jql: " AND assignee WAS \'\($0)\'")  }
        }

        private static func isJson(from options: [Option]) -> Bool {
            return options.first { $0.isJson } != nil
        }

        private static func isAggregate(from options: [Option]) -> Bool {
            return options.first { $0.isAggregate } != nil
        }

        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let config = try facade.configService.loadConfig()

            guard let projectAliasName = parser.shift(), !projectAliasName.isEmpty else {
                throw Error.noProjectAlias
            }

            let projectAlias = try facade.projectService.getAlias(name: projectAliasName)

            guard let second = parser.shift(), !second.isEmpty else {
                throw Error.noDateRange
            }

            let dateRangeJQL: String
            if second == "today" {
                dateRangeJQL = "created >= startOfDay()"
            } else if let fromDate = DateFormatter.core.yyyyMMdd.date(from: second) {
                let toDate = fromDate.addingTimeInterval(60 * 60 * 24)
                let toDateString = DateFormatter.core.yyyyMMdd.string(from: toDate)
                dateRangeJQL = "created >= \'\(second)\' and created <= \'\(toDateString)\'"
            } else {
                let sprints = try facade.sprintService.getSprints(boardID: projectAlias.boardID)
                guard let sprint = sprints.first(where: { $0.name.contains(second) }) else {
                    throw Error.notFoundSprint(second)
                }
                dateRangeJQL = "sprint = \'\(sprint.name)\'"
            }

            let options = (0..<5).compactMap { _ in Option(parser) }
            let _typeJQL = try typeJQL(from: options, facade: facade)
            let _labelJQL = labelJQL(from: options)
            let _statusJQL = try statusJQL(from: options, facade: facade)
            let _userJQL = userJQL(from: options)
            let _isJson = isJson(from: options)
            let _isAggregate = isAggregate(from: options)

            let jql: String
            let aggregateParameters: [AggregateParameter]
            if _isAggregate {
                jql = "project = \(projectAlias.projectID) AND \(dateRangeJQL)"
                aggregateParameters = [.total,
                                       _typeJQL.map { AggregateParameter.type($0.name) },
                                       _labelJQL.map { AggregateParameter.label($0.name) },
                                       _statusJQL.map { AggregateParameter.status($0.name) },
                                       _userJQL.map { AggregateParameter.user($0.name) }]
                    .compactMap { $0 }
            } else {
                jql = "project = \(projectAlias.projectID) AND \(dateRangeJQL)\(_typeJQL?.jql ?? "")\(_labelJQL?.jql ?? "")\(_statusJQL?.jql ?? "")\(_userJQL?.jql ?? "")"
                aggregateParameters = []
            }
            let issues = try facade.issueService.search(jql: jql)

            try printIssues(issues, jql: jql, config: config, isJson: _isJson, aggregateParameters: aggregateParameters)
        }
    }
}

extension Issue.List.Option {
    var isJson: Bool {
        if case .json = self {
            return true
        }
        return false
    }

    var isAggregate: Bool {
        if case .aggregate = self {
            return true
        }
        return false
    }

    var label: String? {
        if case .label(let value) = self {
            return value
        }
        return nil
    }

    var type: String? {
        if case .type(let value) = self {
            return value
        }
        return nil
    }

    var status: String? {
        if case .status(let value) = self {
            return value
        }
        return nil
    }

    var user: String? {
        if case .user(let value) = self {
            return value
        }
        return nil
    }
}

extension Issue.List: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [PROJECT_ALIAS] [today | yyyy/mm/dd | SPRINT_NAME]
                ... Show list of issues with registered `PROJECT_ALIAS`.

            Options:

                -t | --type [ISSUE_TYPE]
                    ... Filter issues with a issueType.
                -l | --label [ISSUE_LABEL]
                    ... Filter issues with a issue label.
                -s | --status [STATUS_NAME]
                    ... Filter issues with a issue status.
                -u | --user [USER_NAME]
                    ... Filter issues with a user who has assigned.
                -a | --aggregate
                    ... Show every options issue counts.
                --output-json
                    ... Print results as JSON format.
        """
    }
}

extension Issue.List.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDateRange:
            return "[today], [yyyy/mm/dd] or [SPRINT_NAME] is required parameter."
        case .noProjectAlias:
            return "PROJECT_ALIAS is required parameter."
        case .notFoundSprint(let param):
            return "\(param) not found in sprints."
        }
    }
}

