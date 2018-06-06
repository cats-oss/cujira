//
//  RequestProxy.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum RequestProxyError: Error {
    case invalidURL(String)
    case createAuthDataFaild(username: String, apiKey: String)
}

struct RequestProxy<T: Request>: Request {
    typealias Response = T.Response

    let baseURL: URL
    let path: String
    let method: HttpMethod
    let endpoint: Endpoint
    let headerField: [String: String]
    let bodyParameter: BodyParameter?
    let queryParameter: [String : String]?

    init(request: T, config: Config) throws {
        let urlString = "https://\(config.domain).atlassian.net/rest/\(request.endpoint.rawValue)"
        self.baseURL = try URL(string: urlString) ?? {
            throw RequestProxyError.invalidURL(urlString)
        }()
        let authData = try "\(config.username):\(config.apiKey)".data(using: .utf8) ?? {
            throw RequestProxyError.createAuthDataFaild(username: config.username, apiKey: config.apiKey)
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

    static func object(from data: Data) throws -> Response {
        return try T.object(from: data)
    }
}
