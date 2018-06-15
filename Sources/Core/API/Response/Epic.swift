//
//  Epic.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/14.
//

import Foundation

public struct Epic: ListableResponse {
    public static let keyOfList: String = "values"

    public let id: Int
    public let name: String
    public let `self`: String
    public let summary: String
    public let key: String
    public let color: Color
    public let done: Bool
}

extension Epic {
    public struct Color: Codable {
        let key: String
    }
}
