//
//  URLRequestBuilder.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

public enum URLRequestBuilder {
    public enum Error: Swift.Error {
        case noURLCompponets(URL)
        case addingQueryFaild(url: URL, query: [String: String])
    }

    public static func build<T: Request>(_ proxy: RequestProxy<T>) throws -> URLRequest {
        let baseURL = proxy.baseURL.appendingPathComponent(proxy.path)

        let url: URL
        if let queryParameter = proxy.queryParameter {
            var components = try URLComponents(string: baseURL.absoluteString) ?? {
                throw Error.noURLCompponets(baseURL)
            }()
            components.queryItems = queryParameter.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            url = try components.url ?? {
                throw Error.addingQueryFaild(url: baseURL, query: queryParameter)
            }()
        } else {
            url = baseURL
        }

        var request = URLRequest(url: url)
        proxy.headerField.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = proxy.method.rawValue
        request.httpBody = try proxy.bodyParameter?.data()

        return request
    }
}

extension URLRequestBuilder.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noURLCompponets(let url):
            return "Failed to create URLCompponets from \(url.absoluteString)"
        case .addingQueryFaild(let url, let query):
            return "Failed adding \(query) to \(url)"
        }
    }
}
