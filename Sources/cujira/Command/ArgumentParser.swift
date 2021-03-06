//
//  ArgumentParser.swift
//  cujira
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
    private(set) var commands: [String]

    init(args: [String]) {
        self.commands = [args[0]]
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
            throw Error.shiftFailed(T.usageDescription(commands))
        }
        let command = try T(rawValue: string) ?? {
            throw Error.unreadString("Command not found.\n\n" + T.usageDescription(commands))
        }()

        commands.append(command.rawValue)

        return command
    }

    func runHelp() -> Bool {
        let isHelp = remainder.first(where: { $0.contains("-h") || $0.contains("--help") }) != nil
        if remainder.isEmpty || isHelp {
            print(Root.Command.usageDescription(commands))
            return true
        } else {
            return false
        }
    }

    func runVersion(_ version: String) -> Bool {
        if remainder.first == "--version" {
            print("Current version: \(version)")
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
