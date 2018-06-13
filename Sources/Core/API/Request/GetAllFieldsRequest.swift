//
//  GetAllFieldsRequest.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

/// - seealso: https://developer.atlassian.com/cloud/jira/platform/rest/#api-api-2-field-get
public struct GetAllFieldsRequest: ApiRequest {
    public typealias Response = [Field]
    public var path: String {
        return "/field"
    }
    public let method: HttpMethod = .get

    public init() {}
}
