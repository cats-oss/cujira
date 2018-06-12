//
//  User.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct User: Codable {
    public let accountId: String
    public let active: Bool
    public let displayName: String
    public let emailAddress: String
    public let key: String
    public let name: String
    public let `self`: URL
    public let timeZone: String
}
