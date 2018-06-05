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
    let bodyParameter: BodyParameter? = DictionaryBodyParameter(dictionary: ["jql": "project = API AND fixVersion = v1.0.0 AND labels = 正常系"])
}
