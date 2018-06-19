//
//  Issue.JQL.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation
import Core

extension Issue {
    enum JQL {
        enum Error: Swift.Error {
            case noParameter
            case noJQLAlias
        }

        static func run(_ parser: ArgumentParser, facade: Facade) throws {
            let config = try facade.config.current(unsafe: false)

            guard let first = parser.shift(), !first.isEmpty else {
                throw Error.noParameter
            }

            let jql: String
            if first == "-a" || first == "--alias" {
                guard let name = parser.shift(), !name.isEmpty else {
                    throw Error.noJQLAlias
                }
                jql = try facade.jql.alias(name: name).jql
            } else {
                jql = first
            }

            let isJson: Bool
            if let j = parser.shift(), !j.isEmpty {
                isJson = j == "--output-json"
            } else {
                isJson = false
            }

            let results = try facade.issue.search(jql: jql)

            try printIssueResults(results, jql: jql, config: config, isJson: isJson, aggregateParameters: [], isAllIssues: true)
        }
    }
}

extension Issue.JQL: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [JQL_STRING]
                ... Show issues with a raw JQL like below. `cujira issue jql "project = 12345 AND issueType = BUG"`.
            + \(cmd) [-a | --alias] [JQL_ALIAS]
                ... Show issues with a registered `JQL_ALIAS`. Please check aliases with `cujira alias jql list`.

            Options:

                --output-json
                    ... Print results as JSON format.

            Other:
                JQL feilds reference ... https://confluence.atlassian.com/jiracoreserver073/advanced-searching-fields-reference-861257219.html
        """
    }
}

extension Issue.JQL.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noParameter:
            return "[JQL] or --alias [JQL_ALIAS] is required parameter."
        case .noJQLAlias:
            return "[JQL_ALIAS] is required paramter."
        }
    }
}
