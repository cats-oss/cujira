//
//  SearchRequest.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

/// - seealso: https://confluence.atlassian.com/jiracoreserver073/advanced-searching-861257209.html?_ga=2.22148987.1713364177.1528079262-1650371415.1484040988
public struct SearchRequest: ApiRequest {
    public enum FieldParameter: String {
        case all = "*all"
        case navigable = "*navigable"
        case exceptComment = "-comment"
    }

    public typealias Response = ListResponse<Issue>
    public let path = "/search"
    public let method: HttpMethod = .post
    public let bodyParameter: BodyParameter?

    private let customFields: [String]

    public init(jql: String, fieldParameters: [FieldParameter] = [.navigable], startAt: Int?, customFields: [String] = []) {
        var dict: [String: Any] = ["jql": jql, "fields": fieldParameters.map { $0.rawValue }]
        if let startAt = startAt {
            dict["startAt"] = "\(startAt)"
        }
        self.bodyParameter = DictionaryBodyParameter(dictionary: dict)
        self.customFields = customFields
    }

    public func object(from data: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.core.iso8601
        decoder.userInfo = [Issue.Fields.customFieldsKey: customFields]
        return try decoder.decode(Response.self, from: data)
    }
}
