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
    private let root: String

    init(args: [String]) {
        self.root = args[0]
        self.remainder = args.dropFirst().map { $0 }
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
            throw Error.shiftFailed(T.usageDescription(root))
        }
        return try T(rawValue: string)
            ?? { throw Error.unreadString("Command not found.\n\n" + T.usageDescription(root)) }()
    }

    func runHelp() -> Bool {
        let isHelp = remainder.first(where: { $0.contains("-h") || $0.contains("--help") }) != nil
        if remainder.isEmpty || isHelp {
            print(Root.Command.usageDescription(root))
            return true
        } else {
            return false
        }
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
