//
//  RequestProxy.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

public enum RequestProxyError: Error {
    case invalidURL(String)
    case createAuthDataFaild(username: String, apiKey: String)
}

/// 　A Request that inject API common required parameters (`domain`, `apikey` and `username`).
///
/// - note: All requests convert to RequestProxy in JiraSession.
public struct RequestProxy<T: Request>: Request {
    public typealias Response = T.Response

    public let baseURL: URL
    public let path: String
    public let method: HttpMethod
    public let endpoint: Endpoint
    public let headerField: [String: String]
    public let bodyParameter: BodyParameter?
    public let queryParameter: [String : String]?

    private let request: T

    public init(request: T, domain: String, apiKey: String, username: String) throws {
        let urlString = "https://\(domain).atlassian.net/rest/\(request.endpoint.rawValue)"
        self.baseURL = try URL(string: urlString) ?? {
            throw RequestProxyError.invalidURL(urlString)
        }()

        /// create auth data from `username` and `apikey`.
        ///
        /// - seealso: https://developer.atlassian.com/cloud/jira/platform/jira-rest-api-basic-authentication/
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
        self.request = request
    }

    public func object(from data: Data) throws -> Response {
        return try request.object(from: data)
    }
}

extension RequestProxyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "\(url) is invalid URL."
        case .createAuthDataFaild(let username, let apiKey):
            return "Failed to create auth date from \(username) and \(apiKey)."
        }
    }
}
