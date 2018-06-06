//
//  SearchRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

/// - seealso: https://confluence.atlassian.com/jiracoreserver073/advanced-searching-861257209.html?_ga=2.22148987.1713364177.1528079262-1650371415.1484040988
struct SearchRequest: ApiRequest {
    typealias Response = ListResponse<Issue>
    let path = "/search"
    let method: HttpMethod = .post
    let bodyParameter: BodyParameter?
    init(jql: String) {
        self.bodyParameter = DictionaryBodyParameter(dictionary: ["jql": jql])
    }
}
