//
//  GetAllStatusesRequest.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

/// - seealso: https://developer.atlassian.com/cloud/jira/platform/rest/#api-api-2-status-get
public struct GetAllStatusesRequest: ApiRequest {
    public typealias Response = [Status]
    public var path: String {
        return "/status"
    }
    public let method: HttpMethod = .get

    public init() {}
}
