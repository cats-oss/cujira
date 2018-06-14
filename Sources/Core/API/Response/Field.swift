//
//  Field.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct Field: Codable {
    public let id: String
    public let name: String
    public let custom: Bool
    public let orderable: Bool
    public let navigable: Bool
    public let searchable: Bool
    public let clauseNames: [String]
    public let schema: Schema?
}

extension Field {
    public struct Schema: Codable {
        public let type: String
        public let system: String?
    }
}
