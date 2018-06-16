//
//  AliasCustomField.Command.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/15.
//

import Core
import Foundation

enum AliasCustomField {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        do {
            switch command {
            case .epiclink:
                try EpicLink.run(parser, facade: facade)
            case .storypoint:
                try StoryPoint.run(parser, facade: facade)
            }
        } catch {
            throw Root.Error(inner: error, usage: AliasCustomField.Command.usageDescription(command.rawValue))
        }
    }

    enum Command: String, CommandList {
        case epiclink
        case storypoint
    }

    enum EpicLink {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
//            guard let name = parser.shift(), !name.isEmpty else {
//                throw Error.noName
//            }
//
//            guard let jql = parser.shift(), !jql.isEmpty else {
//                throw Error.noJQL
//            }
//
//            try facade.jqlService.addAlias(name: name, jql: jql)
        }
    }

    enum StoryPoint {
        static func run(_ parser: ArgumentParser, facade: Facade) throws {
//            guard let name = parser.shift(), !name.isEmpty else {
//                throw Error.noName
//            }
//
//            guard let jql = parser.shift(), !jql.isEmpty else {
//                throw Error.noJQL
//            }
//
//            try facade.jqlService.addAlias(name: name, jql: jql)
        }
    }
}
