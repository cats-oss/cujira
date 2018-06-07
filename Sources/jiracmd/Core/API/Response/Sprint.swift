//
//  Sprint.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

struct Sprint: ListableResponse {
    static let key: String = "values"

    let completeDate: Date?
    let endDate: Date?
    let id: Int
    let name: String
    let originBoardId: Int?
    let `self`: String
    let startDate: Date?
    let state: String
    let goal: String?
}
