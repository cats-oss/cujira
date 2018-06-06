//
//  SearchRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

struct SearchRequest: Request {
    typealias Response = ListResponse<Issue>
    let path = "/search"
    let method: HttpMethod = .post
    let bodyParameter: BodyParameter?
    init(jql: String) {
        self.bodyParameter = DictionaryBodyParameter(dictionary: ["jql": jql])
    }
}
