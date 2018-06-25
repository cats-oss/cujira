//
//  Issue.Search.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation
import Core

extension Issue {
    enum Search {
        enum Error: Swift.Error {
            case noDateRange
            case noFirstParameter
            case noBoardID
            case noProjectInBoard(Board)
            case notFoundSprint(String)
        }

        fileprivate enum Option {
            case issueType(String)
            case label(String)
            case status(String)
            case assigned(String)
            case epicLink(String)
            case json
            case aggregate
            case allIssues

            init?(_ parser: ArgumentParser) {
                if let option = parser.shift(), !option.isEmpty {
                    switch option {
                    case "--issue-type":
                        if let t = parser.shift(), !t.isEmpty {
                            self = .issueType(t)
                            return
                        }
                    case "--label":
                        if let l = parser.shift(), !l.isEmpty {
                            self = .label(l)
                            return
                        }
                    case "--status":
                        if let s = parser.shift(), !s.isEmpty {
                            self = .status(s)
                            return
                        }
                    case "--assigned":
                        if let u = parser.shift(), !u.isEmpty {
                            self = .assigned(u)
                            return
                        }
                    case "--epic-link":
                        if let e = parser.shift(), !e.isEmpty {
                            self = .epicLink(e)
                            return
                        }
                    case "--output-json":
                        self = .json
                        return

                    case "--all-issues":
                        self = .allIssues
                        return

                    case "--aggregate":
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

        private static func issueType(from options: [Option], facade: Facade) throws -> JQLContainer? {
            guard let typeName = options.lazy.compactMap({ $0.issueType }).first else {
                return nil
            }

            let type = try facade.issue.issueType(name: typeName)
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

            let status = try facade.issue.status(name: statusName)
            return JQLContainer(name: statusName, jql: " AND status = \(status.id)")
        }

        private static func assignedJQL(from options: [Option]) -> JQLContainer? {
            return options.lazy.compactMap { $0.assigned }.first
                .map { JQLContainer(name: $0, jql: " AND assignee WAS \'\($0)\'")  }
        }

        private static func epicLinkJQL(from options: [Option]) -> JQLContainer? {
            return options.lazy.compactMap { $0.epicLink }.first
                .map { JQLContainer(name: $0, jql: " AND \'epic link\' = \'\($0)\'")  }
        }

        private static func isJson(from options: [Option]) -> Bool {
            return options.first { $0 == .json } != nil
        }

        private static func isAggregate(from options: [Option]) -> Bool {
            return options.first { $0 == .aggregate } != nil
        }

        private static func isAllIssues(from options: [Option]) -> Bool {
            return options.first { $0 == .allIssues } != nil
        }

        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let config = try facade.config.current(unsafe: false)

            guard let first = parser.shift(), !first.isEmpty else {
                throw Error.noFirstParameter
            }

            let boardID: Int
            if first == "--board-id" {
                guard let id = parser.shift().flatMap(Int.init) else {
                    throw Error.noBoardID
                }
                boardID = id
            } else {
                let projectAlias = try facade.project.alias(name: first)
                boardID = projectAlias.boardID
            }

            let board = try facade.board.board(boardID: boardID, useCache: true)
            guard let projectID = board.location.project?.projectId else {
                throw Error.noProjectInBoard(board)
            }

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
                let sprint = try facade.sprint.sprint(boardID: boardID, name: second, useCache: true)
                dateRangeJQL = "sprint = \'\(sprint.name)\'"
            }

            let options = (0..<5).compactMap { _ in Option(parser) }
            let _issueTypeJQL = try issueType(from: options, facade: facade)
            let _labelJQL = labelJQL(from: options)
            let _statusJQL = try statusJQL(from: options, facade: facade)
            let _assignedJQL = assignedJQL(from: options)
            let _epicLink = epicLinkJQL(from: options)
            let _isJson = isJson(from: options)
            let _isAggregate = isAggregate(from: options)
            let _isAllIssues = isAllIssues(from: options)

            let jql: String
            let aggregateParameters: [AggregateParameter]
            if _isAggregate {
                jql = "project = \(projectID) AND \(dateRangeJQL)"
                aggregateParameters = [.total,
                                       _issueTypeJQL.map { AggregateParameter.type($0.name) },
                                       _labelJQL.map { AggregateParameter.label($0.name) },
                                       _statusJQL.map { AggregateParameter.status($0.name) },
                                       _assignedJQL.map { AggregateParameter.user($0.name) },
                                       _epicLink.map { AggregateParameter.epicLink($0.name) }]
                    .compactMap { $0 }
            } else {
                jql = "project = \(projectID) AND \(dateRangeJQL)" +
                    "\(_issueTypeJQL?.jql ?? "")" +
                    "\(_labelJQL?.jql ?? "")" +
                    "\(_statusJQL?.jql ?? "")" +
                    "\(_assignedJQL?.jql ?? "")" +
                    "\(_epicLink?.jql ?? "")"
                aggregateParameters = []
            }
            let results = try facade.issue.search(jql: jql)

            try printIssueResults(results, jql: jql, config: config, isJson: _isJson, aggregateParameters: aggregateParameters, isAllIssues: _isAllIssues)
        }
    }
}

extension Issue.Search.Option: Equatable {
    static func == (lhs: Issue.Search.Option, rhs: Issue.Search.Option) -> Bool {
        switch (lhs, rhs) {
        case (.json, json),
             (.aggregate, .aggregate),
             (.label, .label),
             (.issueType, .issueType),
             (.status, .status),
             (.assigned, .assigned),
             (.allIssues, .allIssues),
             (.epicLink, .epicLink):
            return true
        default:
            return false
        }
    }

    var label: String? {
        if case .label(let value) = self {
            return value
        }
        return nil
    }

    var issueType: String? {
        if case .issueType(let value) = self {
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

    var assigned: String? {
        if case .assigned(let value) = self {
            return value
        }
        return nil
    }

    var epicLink: String? {
        if case .epicLink(let value) = self {
            return value
        }
        return nil
    }
}

extension Issue.Search: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [PROJECT_ALIAS] [today | yyyy/mm/dd | SPRINT_NAME]
                ... Show list of issues with registered `PROJECT_ALIAS`.
            + \(cmd) [--board-id BOARD_ID] [today | yyyy/mm/dd | SPRINT_NAME]
                ... Show list of issues with `BOARD_ID`.

            Options:

                --issus-type [ISSUE_TYPE]
                    ... Filter issues with a issueType.
                --label [ISSUE_LABEL]
                    ... Filter issues with a issue label.
                --status [STATUS_NAME]
                    ... Filter issues with a issue status.
                --assigned [USER_NAME]
                    ... Filter issues with a user who has assigned.
                --epic-link [EPIC_LINK]
                    ... Filter issues with a epic link.
                --aggregate
                    ... Show every options issue counts.
                --all-issues
                    ... Print all issues to ignore options. (This option is only available to use `--aggreegate`)
                --output-json
                    ... Print results as JSON format.
        """
    }
}

extension Issue.Search.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDateRange:
            return "[today], [yyyy/mm/dd] or [SPRINT_NAME] is required parameter."
        case .noFirstParameter:
            return "[PROJECT_ALIAS] or [--board-id BOARD_ID] is required parameter."
        case .noBoardID:
            return "[BOARD_ID] is required parameter."
        case .noProjectInBoard(let board):
            return "BoardID: \(board.id) has no project"
        case .notFoundSprint(let param):
            return "[\(param)] not found in sprints."
        }
    }
}

