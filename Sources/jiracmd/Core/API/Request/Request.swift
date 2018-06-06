//
//  Request.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Endpoint: String {
    case agile = "/agile/1.0"
    case api = "/api/2"
}

protocol Request {
    associatedtype Response
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var endpoint: Endpoint { get }
    var headerField: [String: String] { get }
    var bodyParameter: BodyParameter? { get }

    static func object(from data: Data) throws -> Response
}

extension Request {
    var baseURL: URL {
        fatalError("use RequestProxy")
    }

    var headerField: [String: String] {
        return [:]
    }

    var bodyParameter: BodyParameter? {
        return nil
    }
}

extension Request where Response: Decodable {
    static func object(from data: Data) throws -> Response {

        print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))

        return try JSONDecoder().decode(Response.self, from: data)
    }
}

/// - seealso: https://developer.atlassian.com/cloud/jira/software/rest/#introduction
protocol AgileRequest: Request {}

extension AgileRequest {
    var endpoint: Endpoint {
        return .agile
    }
}

/// - seealso: https://developer.atlassian.com/cloud/jira/platform/rest/
protocol ApiRequest: Request {}

extension ApiRequest {
    var endpoint: Endpoint {
        return .api
    }
}
