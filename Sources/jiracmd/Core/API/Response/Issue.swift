//
//  Issue.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

struct Issue: Decodable {
    let id: String
    let key: String
}

extension Issue: ListableResponse {
    static let key = "issues"
}
