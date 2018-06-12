//
//  IssueAggregation.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct IssueAggregation: Codable {
    public struct Aggregation: Codable {
        public let issues: [Issue]
        public let name: String
        public let count: Int
        public let percentage: Double

        public init(issues: [Issue], name: String, count: Int, percentage: Double) {
            self.issues = issues
            self.name = name
            self.count = count
            self.percentage = percentage
        }
    }

    let aggregations: [Aggregation]

    public init(aggregations: [Aggregation]) {
        self.aggregations = aggregations
    }
}
