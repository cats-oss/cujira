//
//  Sprint.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

public struct Sprint: ListableResponse {
    public static let keyOfList: String = "values"

    public let completeDate: Date?
    public let endDate: Date?
    public let id: Int
    public let name: String
    public let originBoardId: Int?
    public let `self`: String
    public let startDate: Date?
    public let state: String
    public let goal: String?
}
