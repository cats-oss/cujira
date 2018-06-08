//
//  GetAllBoardsRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

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
