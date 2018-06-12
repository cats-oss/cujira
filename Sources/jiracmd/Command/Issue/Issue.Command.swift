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
            do {
                try List.run(parser)
            } catch {
                throw Root.Error(inner: error, usage: Issue.List.usageDescription(parser.root))
            }
        case .jql:
            do {
                try JQL.run(parser)
            } catch {
                throw Root.Error(inner: error, usage: Issue.JQL.usageDescription(parser.root))
            }
        }
    }

    enum Command: String, CommandList {
        case list
        case jql
    }

    enum Error: Swift.Error {
        case noProjectAlias
        case noDateRange
        case notFoundSprint(String)
        case noParameter
        case noJQLAlias
    }

    fileprivate enum AggregateParameter {
        case total
        case label(String)
        case type(String)
    }

    enum List {
        fileprivate enum Option {
            case type(String)
            case label(String)
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

        private static func typeJQL(from options: [Option]) -> JQLContainer? {
            return options.lazy.compactMap { $0.type }.first
                .map { JQLContainer(name: $0, jql: " AND type = \'\($0)\'") }
        }

        private static func labelJQL(from options: [Option]) -> JQLContainer? {
            return options.lazy.compactMap { $0.label }.first
                .map { JQLContainer(name: $0, jql: " AND labels = \'\($0)\'")  }
        }

        private static func isJson(from options: [Option]) -> Bool {
            return options.first { $0.isJson } != nil
        }

        private static func isAggregate(from options: [Option]) -> Bool {
            return options.first { $0.isAggregate } != nil
        }

        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
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
            let _typeJQL = typeJQL(from: options)
            let _labelJQL = labelJQL(from: options)
            let _isJson = isJson(from: options)
            let _isAggregate = isAggregate(from: options)


            let jql: String
            let aggregateParameters: [AggregateParameter]
            if _isAggregate {
                jql = "project = \(projectAlias.projectID) AND \(dateRangeJQL)"
                aggregateParameters = [.total,
                                       _typeJQL.map { AggregateParameter.type($0.name) },
                                       _labelJQL.map { AggregateParameter.label($0.name) }]
                    .compactMap { $0 }
            } else {
                jql = "project = \(projectAlias.projectID) AND \(dateRangeJQL)\(_typeJQL?.jql ?? "")\(_labelJQL?.jql ?? "")"
                aggregateParameters = []
            }
            let issues = try facade.issueService.search(jql: jql)

            try printIssues(issues, jql: jql, config: config, isJson: _isJson, aggregateParameters: aggregateParameters)
        }
    }

    enum JQL {
        static func run(_ parser: ArgumentParser, facade: Facade = .init()) throws {
            let config = try facade.configService.loadConfig()

            guard let first = parser.shift(), !first.isEmpty else {
                throw Error.noParameter
            }

            let jql: String
            if first == "-r" || first == "--registered" {
                guard let name = parser.shift(), !name.isEmpty else {
                    throw Error.noJQLAlias
                }
                jql = try facade.jqlService.getAlias(name: name).jql
            } else {
                jql = first
            }

            let isJson: Bool
            if let j = parser.shift(), !j.isEmpty {
                isJson = j == "--output-json"
            } else {
                isJson = false
            }

            let issues = try facade.issueService.search(jql: jql)

            try printIssues(issues, jql: jql, config: config, isJson: isJson, aggregateParameters: [])
        }
    }

    private static func printIssues(_ issues: [Core.Issue],
                                    jql: String,
                                    config: Config,
                                    isJson: Bool,
                                    aggregateParameters: [AggregateParameter]) throws {

        typealias Aggregation = IssueAggregation.Aggregation

        func countInfoList(issues: [Core.Issue], aggregateParameters: [AggregateParameter]) -> [Aggregation] {
            return aggregateParameters.map {
                switch $0 {
                case .total:
                    return Aggregation(issues: issues, name: "Issues", count: issues.count, percentage: 1)
                case .label(let name):
                    let filteredIssues = issues.filter { $0.fields.labels.first { $0 == name } != nil }
                    let count = filteredIssues.count
                    let percentage = Double(count) / Double(issues.count)
                    return Aggregation(issues: filteredIssues, name: name, count: count, percentage: percentage)
                case .type(let name):
                    let filteredIssues = issues.filter { $0.fields.issuetype.name == name }
                    let count = filteredIssues.count
                    let percentage = Double(count) / Double(issues.count)
                    return Aggregation(issues: filteredIssues, name: name, count: count, percentage: percentage)
                }
            }
        }

        if isJson {
            let data: Data
            if aggregateParameters.isEmpty {
                data = try JSONEncoder().encode(issues)
            } else {
                let aggregations = countInfoList(issues: issues, aggregateParameters: aggregateParameters)
                let aggregation = IssueAggregation(aggregations: aggregations)
                data = try JSONEncoder().encode(aggregation)
            }

            let jsonString = String(data: data, encoding: .utf8) ?? "{}"
            print(jsonString)
        } else {
            print("JQL: \(jql)")

            if aggregateParameters.isEmpty {
                issues.forEach { issues in
                    print("\nSummary: \(issues.fields.summary)")
                    print("URL: https://\(config.domain).atlassian.net/browse/\(issues.key)")
                }
            } else {
                let filteredIssues = aggregateParameters.reduce(issues) { result, parameter -> [Core.Issue] in
                    switch parameter {
                    case .total:
                        return result
                    case .label(let name):
                        return result.filter { $0.fields.labels.first { $0 == name } != nil }
                    case .type(let name):
                        return result.filter { $0.fields.issuetype.name == name }
                    }
                }

                filteredIssues.forEach { issue in
                    print("\nSummary: \(issue.fields.summary)")
                    print("URL: https://\(config.domain).atlassian.net/browse/\(issue.key)")
                    print("Status: \(issue.fields.status.name)")
                    print("User: \(issue.fields.assignee.map { $0.name } ?? "--")")
                }

                print("")

                let aggregations = countInfoList(issues: issues, aggregateParameters: aggregateParameters)
                aggregations.forEach {
                    print("Number of \($0.name): \($0.count) (\(String(format: "%.1lf", $0.percentage * 100))%)")
                }
            }
        }
    }
}

extension Issue.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDateRange:
            return "[today], [yyyy/mm/dd] or [SPRINT_NAME] is required parameter."
        case .noProjectAlias:
            return "PROJECT_ALIAS is required parameter."
        case .notFoundSprint(let param):
            return "\(param) not found in sprints."
        case .noParameter:
            return "JQL or --registered [JQL_ALIAS] is required parameter."
        case .noJQLAlias:
            return "JQL_ALIAS is required paramter."
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
}
