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

protocol Request {
    associatedtype Response
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
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
