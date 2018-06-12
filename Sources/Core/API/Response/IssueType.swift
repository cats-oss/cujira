//
//  IssueType.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct IssueType: Codable {
    public let description: String
    public let iconUrl: URL
    public let id: String
    public let name: String
    public let `self`: URL
    public let subtask: Bool
}
