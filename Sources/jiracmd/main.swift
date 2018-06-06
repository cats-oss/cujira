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
    try Root.run(parser)
} catch {
    print(error.localizedDescription)
}
