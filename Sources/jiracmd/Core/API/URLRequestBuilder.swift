//
//  URLRequestBuilder.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

enum URLRequestBuilder {
    static func build<T: Request>(_ proxy: RequestProxy<T>) throws -> URLRequest {
        var request = URLRequest(url: proxy.baseURL.appendingPathComponent(proxy.path))

        proxy.headerField.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = proxy.method.rawValue
        request.httpBody = try proxy.bodyParameter?.data()

        return request
    }
}
