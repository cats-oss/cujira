//
//  GetEpicRequest.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/14.
//

import Foundation

/// - seealso: https://developer.atlassian.com/cloud/jira/software/rest/#api-board-boardId-epic-get
public struct GetEpicRequest: AgileRequest {
    public typealias Response = ListResponse<Epic>
    public var path: String {
        return "/board/\(boardID)/epic"
    }
    public let method: HttpMethod = .get
    public var queryParameter: [String : String]? {
        return ["startAt": "\(startAt)"]
    }

    public let boardID: Int
    public let startAt: Int

    public init(boardID: Int, startAt: Int = 0) {
        self.boardID = boardID
        self.startAt = startAt
    }
}
