//
//  GetAllBoardsRequest.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

/// - seealso: https://developer.atlassian.com/cloud/jira/software/rest/#api-board-get
public struct GetAllBoardsRequest: AgileRequest {
    public typealias Response = ListResponse<Board>
    public let path = "/board"
    public let method: HttpMethod = .get
    public var queryParameter: [String : String]? {
        guard let startAt = startAt else {
            return nil
        }
        return ["startAt": "\(startAt)"]
    }

    public let startAt: Int?

    public init(startAt: Int?) {
        self.startAt = startAt
    }
}
