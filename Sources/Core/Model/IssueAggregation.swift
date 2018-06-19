//
//  IssueAggregation.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

/// An issue aggregation result object.
public struct IssueAggregation: Codable {
    public let issueResults: [IssueResult]
    public let name: String
    public let count: Int

    public init(issueResults: [IssueResult], name: String, count: Int) {
        self.issueResults = issueResults
        self.name = name
        self.count = count
    }
}
