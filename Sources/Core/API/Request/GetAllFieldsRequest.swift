//
//  GetAllFieldsRequest.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

public struct GetAllFieldsRequest: ApiRequest {
    public typealias Response = [Field]
    public var path: String {
        return "/field"
    }
    public let method: HttpMethod = .get

    public init() {}
}
