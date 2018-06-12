//
//  GetAllIssueTypesRequest.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

public struct GetAllIssueTypesRequest: ApiRequest {
    public typealias Response = [IssueType]
    public var path: String {
        return "/issuetype"
    }
    public let method: HttpMethod = .get

    public init() {}
}
