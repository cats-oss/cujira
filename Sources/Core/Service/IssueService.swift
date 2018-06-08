//
//  IssueService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public final class IssueService {
    private let session: JiraSession

    public init(session: JiraSession) {
        self.session = session
    }

    public func search(jql: String, limit: Int = 500) throws -> [Issue] {
        func recursiveFetch(startAt: Int, list: [Issue]) throws -> [Issue] {
            let response = try session.send(SearchRequest(jql: jql, startAt: startAt))
            let values = response.values
            let newList = list + values
            let isLast = values.isEmpty ? true : (response.total ?? 0) == newList.count
            if isLast || newList.count >= limit {
                return newList
            } else {
                return try recursiveFetch(startAt: newList.count, list: newList)
            }
        }

        return try recursiveFetch(startAt: 0, list: [])
    }
}
