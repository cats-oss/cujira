//
//  GetAllBoardsRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

import Foundation

struct GetAllBoardsRequest: AgileRequest {
    typealias Response = ListResponse<Board>
    let path = "/board"
    let method: HttpMethod = .get

    init() {
    }
}
