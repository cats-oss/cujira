//
//  JiraSession.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

final class JiraSession {
    enum Result<T> {
        case success(T)
        case failure(Swift.Error)
    }

    enum Error: Swift.Error {
        case emptyResult
        case invalidResopnse(HTTPURLResponse)
        case unknown
    }

    struct ErrorMessage: Swift.Error, Decodable {
        let errorMessages: [String]
    }

    private let session: URLSession
    private let configManager: ConfigManager

    init(session: URLSession = .shared,
         configManager: ConfigManager = .shared) {
        self.session = session
        self.configManager = configManager
    }

    func send<T: Request>(_ request: T) throws -> T.Response {
        let proxy = try RequestProxy(request: request, config: configManager.loadConfig())
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
    var errorDescription: String? {
        return errorMessages.first
    }
}
