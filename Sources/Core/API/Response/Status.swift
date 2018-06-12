//
//  Status.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct Status: Codable {
    public let `self`: URL
    public let description: String
    public let iconUrl: URL
    public let name: String
    public let id: String
    public let statusCategory: Category?
}

extension Status {
    public struct Category: Codable {
        public let `self`: URL
        public let id: Int
        public let key: String
        public let colorName: String
    }
}
