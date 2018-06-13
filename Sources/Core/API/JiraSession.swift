//
//  JiraSession.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

public final class JiraSession {
    public enum Result<T> {
        case success(T)
        case failure(Swift.Error)
    }

    public enum Error: Swift.Error {
        case emptyResult
        case invalidResopnse(HTTPURLResponse)
        case unknown
    }

    public struct ErrorMessage: Swift.Error, Decodable {
        public let errorMessages: [String]
    }

    private let domain: () throws -> (String)
    private let apiKey: () throws -> (String)
    private let username: () throws -> (String)


    private let session: URLSession

    public init(session: URLSession = .shared,
                domain: @escaping () throws -> (String),
                apiKey: @escaping () throws -> (String),
                username: @escaping () throws -> (String)) {
        self.session = session
        self.domain = domain
        self.apiKey = apiKey
        self.username = username
    }

    public func send<T: Request>(_ request: T) throws -> T.Response {
        let proxy = try RequestProxy(request: request,
                                     domain: domain(),
                                     apiKey: apiKey(),
                                     username: username())
        let result = try sendSync(proxy)
        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    private func sendSync<T: Request>(_ proxy: RequestProxy<T>) throws -> Result<T.Response> {
        let semaphore = DispatchSemaphore(value: 0)
        let request = try URLRequestBuilder.build(proxy)
        
        var result: Result<T.Response>?
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                do {
                    let object = try T.object(from: data)
                    result = .success(object)
                } catch {
                    if let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: data) {
                        result = .failure(errorMessage)
                    } else {
                        result = .failure(error)
                    }
                }
            } else if let response = response as? HTTPURLResponse {
                result = .failure(Error.invalidResopnse(response))
            } else {
                result = .failure(Error.unknown)
            }
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()

        return try result ?? {
            throw Error.emptyResult
        }()
    }
}

extension JiraSession.ErrorMessage: LocalizedError {
    public var errorDescription: String? {
        return errorMessages.first
    }
}

extension JiraSession.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyResult:
            return "Empty Result."
        case .invalidResopnse(let resposne):
            return "Invalid response (status code: \(resposne.statusCode)"
        case .unknown:
            return "Unknown error occured."
        }
    }
}
