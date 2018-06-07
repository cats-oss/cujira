//
//  GetAllSprintsRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

struct GetAllSprintsRequest: AgileRequest {
    typealias Response = ListResponse<Sprint>
    var path: String {
        return "/board/\(boardId)/sprint"
    }
    let method: HttpMethod = .get
    var queryParameter: [String : String]? {
        guard let startAt = startAt else {
            return nil
        }
        return ["startAt": "\(startAt)"]
    }

    let boardId: Int
    let startAt: Int?

    init(boardId: Int, startAt: Int?) {
        self.boardId = boardId
        self.startAt = startAt
    }
}
