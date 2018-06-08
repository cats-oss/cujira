//
//  RequestProxy.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

public enum RequestProxyError: Error {
    case invalidURL(String)
    case createAuthDataFaild(username: String, apiKey: String)
}

public struct RequestProxy<T: Request>: Request {
    public typealias Response = T.Response

    public let baseURL: URL
    public let path: String
    public let method: HttpMethod
    public let endpoint: Endpoint
    public let headerField: [String: String]
    public let bodyParameter: BodyParameter?
    public let queryParameter: [String : String]?

    public init(request: T, domain: String, apiKey: String, username: String) throws {
        let urlString = "https://\(domain).atlassian.net/rest/\(request.endpoint.rawValue)"
        self.baseURL = try URL(string: urlString) ?? {
            throw RequestProxyError.invalidURL(urlString)
        }()
        let authData = try "\(username):\(apiKey)".data(using: .utf8) ?? {
            throw RequestProxyError.createAuthDataFaild(username: username, apiKey: apiKey)
        }()
        let base64AuthString = authData.base64EncodedString()
        self.headerField = [
            "Authorization": "Basic \(base64AuthString)", "Content-Type": "application/json"
        ].merging(request.headerField, uniquingKeysWith: +)

        self.path = request.path
        self.method = request.method
        self.endpoint = request.endpoint
        self.bodyParameter = request.bodyParameter
        self.queryParameter = request.queryParameter
    }

    public static func object(from data: Data) throws -> Response {
        return try T.object(from: data)
    }
}
