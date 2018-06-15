//
//  IssueReust.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Foundation

public struct IssueResult: Codable {
    public let issue: Issue
    public let epic: Epic?
    public let storyPoint: Int?
}
