//
//  SprintService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

final class SprintService {
    let session: JiraSession

    init(session: JiraSession) {
        self.session = session
    }

    func fetchAllSprints(boardId: Int) throws -> [Sprint] {
        func recursiveFetch(startAt: Int, list: [Sprint]) throws -> [Sprint] {
            let response = try session.send(GetAllSprintsRequest(boardId: boardId, startAt: startAt))
            let values = response.values
            let isLast = values.isEmpty ? true : response.isLast ?? true
            let newList = list + values
            if isLast {
                return newList
            } else {
                return try recursiveFetch(startAt: values.count, list: newList)
            }
        }

        return try recursiveFetch(startAt: 0, list: [])
    }
}
