//
//  SearchRequest.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

/// - seealso: https://confluence.atlassian.com/jiracoreserver073/advanced-searching-861257209.html?_ga=2.22148987.1713364177.1528079262-1650371415.1484040988
public struct SearchRequest: ApiRequest {
    public typealias Response = ListResponse<Issue>
    public let path = "/search"
    public let method: HttpMethod = .post
    public let bodyParameter: BodyParameter?

    public init(jql: String, startAt: Int?) {
        var dict = ["jql": jql]
        if let startAt = startAt {
            dict["startAt"] = "\(startAt)"
        }
        self.bodyParameter = DictionaryBodyParameter(dictionary: dict)
    }
}
