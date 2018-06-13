//
//  Config.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/04.
//

public struct Config {
    public struct Raw: Codable {
        var domain: String?
        var apiKey: String?
        var username: String?
    }

    public let domain: String
    public let apiKey: String
    public let username: String
}
