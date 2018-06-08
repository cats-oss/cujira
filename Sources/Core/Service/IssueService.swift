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

    public func search(jql: String) throws -> [Issue] {
        let request = SearchRequest(jql: jql)
        return try session.send(request).values
    }
}
