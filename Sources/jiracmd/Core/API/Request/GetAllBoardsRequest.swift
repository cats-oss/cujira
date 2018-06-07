//
//  GetAllBoardsRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

struct GetAllBoardsRequest: AgileRequest {
    typealias Response = ListResponse<Board>
    let path = "/board"
    let method: HttpMethod = .get
    var queryParameter: [String : String]? {
        guard let startAt = startAt else {
            return nil
        }
        return ["startAt": "\(startAt)"]
    }

    let startAt: Int?

    init(startAt: Int?) {
        self.startAt = startAt
    }
}
