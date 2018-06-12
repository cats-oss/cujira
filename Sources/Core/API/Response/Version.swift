//
//  Version.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct Version: Codable {
    public let archived: Bool
    public let description: String
    public let id: String
    public let name: String
    public let released: Bool
    public let `self`: URL
}
