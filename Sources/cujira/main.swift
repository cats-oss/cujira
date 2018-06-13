//
//  main.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/04.
//

import Foundation
import Core

let version = "0.1.0"

let parser = ArgumentParser(args: CommandLine.arguments)

if parser.runHelp() {
    exit(0)
}

if parser.runVersion(version) {
    exit(0)
}

let facade = Facade()

// Set tempConfig when executing command with `env CUJIRA_USER_NAME="XXX" CUJIRA_API_KEY="XXX" CUJIRA_DOMAIN="XXX" cujira`.
facade.configService.setTempConfig(dictionay: ProcessInfo.processInfo.environment)

do {
    try Root.run(parser, facade: facade)
} catch {
    print(error.localizedDescription)
}
