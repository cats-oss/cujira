//
//  JSONDecoder.DateDecodingStrategy.core.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy: CoreCompatible {}

extension CoreExtension where Base == JSONDecoder.DateDecodingStrategy {
    public enum Error: Swift.Error {
        case invalidDate(String)
    }
    
    public static var iso8601: JSONDecoder.DateDecodingStrategy {
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
            throw CoreExtension.Error.invalidDate(string)
        })
    }
}
