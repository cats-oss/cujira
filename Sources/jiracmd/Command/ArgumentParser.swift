//
//  ArgumentParser.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

final class ArgumentParser {
    enum Error: Swift.Error {
        case shiftFailed(String)
        case unreadString(String)
    }

    private var remainder: [String]

    init(args: [String]) {
        self.remainder = args
    }

    @discardableResult
    func shift() -> String? {
        if remainder.isEmpty {
            return nil
        }
        return remainder.removeFirst()
    }

    @discardableResult
    func shiftAll() -> [String] {
        let r = remainder
        remainder = []
        return r
    }

    func parse<T: CommandList>() throws -> T {
        guard let string = shift() else {
            throw Error.shiftFailed(T.usageDescription)
        }
        return try T(rawValue: string)
            ?? { throw Error.unreadString("該当のコマンドは存在しません\n\n" + T.usageDescription) }()
    }
}

extension ArgumentParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .shiftFailed(let desc):
            return desc
        case .unreadString(let desc):
            return desc
        }
    }
}
