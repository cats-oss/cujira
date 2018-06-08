//
//  Request.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Endpoint: String {
    case agile = "/agile/1.0"
    case api = "/api/2"
}

public protocol Request {
    associatedtype Response
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var endpoint: Endpoint { get }
    var headerField: [String: String] { get }
    var bodyParameter: BodyParameter? { get }
    var queryParameter: [String: String]? { get }

    static func object(from data: Data) throws -> Response
}

extension Request {
    public var baseURL: URL {
        fatalError("use RequestProxy")
    }

    public var headerField: [String: String] {
        return [:]
    }

    public var bodyParameter: BodyParameter? {
        return nil
    }

    public var queryParameter: [String: String]? {
        return nil
    }
}

extension Request where Response: Decodable {
    public static func object(from data: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.core.iso8601
        return try decoder.decode(Response.self, from: data)
    }
}

/// Request for Jira Software Cloud Developer REST APIs
///
/// - seealso: https://developer.atlassian.com/cloud/jira/software/rest/#introduction
public protocol AgileRequest: Request {}

extension AgileRequest {
    public var endpoint: Endpoint {
        return .agile
    }
}

/// Request for Jira Cloud platform Developer REST APIs
///
/// - seealso: https://developer.atlassian.com/cloud/jira/platform/rest/
public protocol ApiRequest: Request {}

extension ApiRequest {
    public var endpoint: Endpoint {
        return .api
    }
}
