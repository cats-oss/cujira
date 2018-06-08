//
//  GetAllSprintsRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

public struct GetAllSprintsRequest: AgileRequest {
    public typealias Response = ListResponse<Sprint>
    public var path: String {
        return "/board/\(boardId)/sprint"
    }
    public let method: HttpMethod = .get
    public var queryParameter: [String : String]? {
        guard let startAt = startAt else {
            return nil
        }
        return ["startAt": "\(startAt)"]
    }

    public let boardId: Int
    public let startAt: Int?

    public init(boardId: Int, startAt: Int?) {
        self.boardId = boardId
        self.startAt = startAt
    }
}
