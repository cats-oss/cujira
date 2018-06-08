//
//  main.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/04.
//

import Foundation

let parser = ArgumentParser(args: CommandLine.arguments)

if parser.runHelp() {
    exit(0)
}

do {
    try Root.run(parser)
} catch {
    print(error.localizedDescription)
}
