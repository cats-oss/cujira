//
//  Issue.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

import Core
import Foundation

enum Issue {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        switch command {
        case .list:
            do {
                try List.run(parser, facade: facade)
            } catch {
                throw Root.Error(inner: error, usage: Issue.List.usageDescription(command.rawValue))
            }
        case .jql:
            do {
                try JQL.run(parser, facade: facade)
            } catch {
                throw Root.Error(inner: error, usage: Issue.JQL.usageDescription(command.rawValue))
            }
        }
    }

    enum Command: String, CommandList {
        case list
        case jql
    }

    enum AggregateParameter {
        case total
        case label(String)
        case type(String)
        case user(String)
        case status(String)
        case epicLink(String)
    }

    private typealias Aggregation = IssueAggregation.Aggregation

    private static func aggregations(issues: [Core.Issue], aggregateParameters: [AggregateParameter]) -> [Aggregation] {
        return aggregateParameters.map {
            switch $0 {
            case .total:
                return Aggregation(issues: issues, name: "Issues", count: issues.count)
            case .label(let name):
                let filteredIssues = issues.filter { $0.fields.labels.first { $0 == name } != nil }
                let count = filteredIssues.count
                return Aggregation(issues: filteredIssues, name: name, count: count)
            case .type(let name):
                let filteredIssues = issues.filter { $0.fields.issuetype.name == name }
                let count = filteredIssues.count
                return Aggregation(issues: filteredIssues, name: name, count: count)
            case .user(let name):
                let filteredIssues = issues.filter { $0.fields.assignee?.name == name }
                let count = filteredIssues.count
                return Aggregation(issues: filteredIssues, name: name, count: count)
            case .status(let name):
                let filteredIssues = issues.filter { $0.fields.status.name == name }
                let count = filteredIssues.count
                return Aggregation(issues: filteredIssues, name: name, count: count)
            case .epicLink(let name):
                let filteredIssues = issues.filter { $0.fields.status.name == name }
                let count = filteredIssues.count
                return Aggregation(issues: filteredIssues, name: name, count: count)
            }
        }
    }

    private static func filteredIssues(_ issues: [Core.Issue], by aggregateParameters: [AggregateParameter]) -> [Core.Issue] {
        return aggregateParameters.reduce(issues) { result, parameter -> [Core.Issue] in
            switch parameter {
            case .total:
                return result
            case .label(let name):
                return result.filter { $0.fields.labels.first { $0 == name } != nil }
            case .type(let name):
                return result.filter { $0.fields.issuetype.name == name }
            case .user(let name):
                return result.filter { $0.fields.assignee?.name == name }
            case .status(let name):
                return result.filter { $0.fields.status.name == name }
            case .epicLink(let name):
                return result.filter { $0.fields.status.name == name }
            }
        }
    }

    static func printIssues(_ issues: [Core.Issue],
                            jql: String,
                            config: Config,
                            isJson: Bool,
                            aggregateParameters: [AggregateParameter],
                            isAllIssues: Bool) throws {
        if isJson {
            let data: Data
            if aggregateParameters.isEmpty {
                data = try JSONEncoder().encode(issues)
            } else {
                let _filteredIssues = filteredIssues(issues, by: aggregateParameters)
                let _aggregations = aggregations(issues: issues, aggregateParameters: aggregateParameters)
                let matched = Aggregation(issues: _filteredIssues, name: "Matched Issues", count: _filteredIssues.count)
                let aggregation = IssueAggregation(aggregations: _aggregations + [matched])
                data = try JSONEncoder().encode(aggregation)
            }

            let jsonString = String(data: data, encoding: .utf8) ?? "{}"
            print(jsonString)
        } else {
            print("JQL: \(jql)")

            func printIssues(_ issues: [Core.Issue]) {
                issues.forEach { issue in
                    print("\nSummary: \(issue.fields.summary)")
                    print("URL: https://\(config.domain).atlassian.net/browse/\(issue.key)")
                    print("IssueType: \(issue.fields.issuetype.name)")
                    print("Status: \(issue.fields.status.name)")
                    print("User: \(issue.fields.assignee.map { $0.name } ?? "--")")
                }
            }

            if aggregateParameters.isEmpty {
                printIssues(issues)
            } else {
                let _filteredIssues = filteredIssues(issues, by: aggregateParameters)

                if isAllIssues {
                    printIssues(issues)
                } else {
                    printIssues(_filteredIssues)
                }

                print("")

                let _aggregations = aggregations(issues: issues, aggregateParameters: aggregateParameters)
                _aggregations.forEach {
                    print("Number of \($0.name): \($0.count)")
                }
                print("Number of Matched Issues: \(_filteredIssues.count)")
            }
        }
    }
}
