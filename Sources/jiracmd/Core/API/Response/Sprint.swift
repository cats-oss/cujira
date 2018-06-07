//
//  Sprint.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

struct Sprint: ListableResponse {
    static let key: String = "values"

    let completeDate: String?
    let endDate: String?
    let id: Int
    let name: String
    let originBoardId: Int?
    let `self`: String
    let startDate: String?
    let state: String
    let goal: String?
}
