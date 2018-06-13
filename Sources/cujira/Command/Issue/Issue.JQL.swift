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
}

extension Issue.JQL: UsageDescribable {
    static func usageDescription(_ cmd: String) -> String {
        return """
            + \(cmd) [JQL_STRING]
            + \(cmd) [-r | --registered] [JQL_ALIAS]

            Options:

                --output-json
        """
    }
}

extension Issue.JQL.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noParameter:
            return "JQL or --registered [JQL_ALIAS] is required parameter."
        case .noJQLAlias:
            return "JQL_ALIAS is required paramter."
        }
    }
}
