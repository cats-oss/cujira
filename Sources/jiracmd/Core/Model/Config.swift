//
//  Config.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/04.
//

struct Config {
    struct Raw: Codable {
        var domain: String?
        var apiKey: String?
        var username: String?
    }

    let domain: String
    let apiKey: String
    let username: String
}
