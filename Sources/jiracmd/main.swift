//
//  main.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/04.
//

import Foundation

let arguments = CommandLine.arguments.dropFirst().map { $0 }

if arguments.isEmpty {
    print(Root.Command.usageDescription)
    exit(0)
}

let parser = ArgumentParser(args: arguments)

if arguments.first(where: { $0.contains("-h") || $0.contains("--help") }) != nil {
    parser.shiftAll()
    print(Root.Command.usageDescription)
    exit(0)
}

do {
    let rootCommand: Root.Command = try parser.parse()

    switch rootCommand {
    case .register:
        let subCommand: Register.Command = try parser.parse()
        switch subCommand {
        case .domain:
            try Register.Domain.run(parser)
        case .username:
            try Register.Username.run(parser)
        case .apiKey:
            try Register.ApiKey.run(parser)
        case .info:
            try Register.Info.run(parser)
        }
    case .search:
        try Root.Search.run(parser)
    case .jql:
        let subCommand: JQL.Command = try parser.parse()
        switch subCommand {
        case .add:
            try JQL.Add.run(parser)
        case .remove:
            try JQL.Remove.run(parser)
        case .list:
            try JQL.List.run(parser)
        }
    }
} catch {
    print(error.localizedDescription)
}
