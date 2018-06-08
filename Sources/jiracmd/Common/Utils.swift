//
//  Utils.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

import Foundation

enum Utils {
    enum Error: Swift.Error {
        case invalidDate(String)
    }

    static func fetchAllSprints(boardId: Int, session: JiraSession) throws -> [Sprint] {
        func recursiveFetch(startAt: Int, list: [Sprint]) throws -> [Sprint] {
            let response = try session.send(GetAllSprintsRequest(boardId: boardId, startAt: startAt))
            let values = response.values
            let isLast = values.isEmpty ? true : response.isLast ?? true
            let newList = list + values
            if isLast {
                return newList
            } else {
                return try recursiveFetch(startAt: values.count, list: newList)
            }
        }

        return try recursiveFetch(startAt: 0, list: [])
    }

    static func iso8601DateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        return .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: string) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: string) {
                return date
            }
            throw Error.invalidDate(string)
        })
    }

    static func yyyyMMddDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }
}
