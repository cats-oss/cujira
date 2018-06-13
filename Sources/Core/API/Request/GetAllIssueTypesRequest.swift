//
//  GetAllIssueTypesRequest.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

/// - seealso: https://developer.atlassian.com/cloud/jira/platform/rest/#api-api-2-issuetype-get
public struct GetAllIssueTypesRequest: ApiRequest {
    public typealias Response = [IssueType]
    public var path: String {
        return "/issuetype"
    }
    public let method: HttpMethod = .get

    public init() {}
}
