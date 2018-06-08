//
//  IssueService.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

final class IssueService {
    let session: JiraSession

    init(session: JiraSession) {
        self.session = session
    }

    func search(jql: String) throws -> [Issue] {
        let request = SearchRequest(jql: jql)
        return try session.send(request).values
    }
}
