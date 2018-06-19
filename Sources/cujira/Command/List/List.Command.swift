//
//  List.Command.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/18.
//

import Core
import Foundation

enum List {
    static func run(_ parser: ArgumentParser, facade: Facade) throws {
        let command: Command = try parser.parse()

        switch command {
        case .sprint:
            do {
                try Sprint.run(parser, facade:facade)
            } catch {
                throw Root.Error(inner: error, usage: List.Sprint.usageDescriptionAndOptions(command.rawValue))
            }
        case .field:
            do {
                try Field.run(parser, facade: facade)
            } catch {
                throw Root.Error(inner: error, usage: List.Field.usageDescriptionAndOptions(command.rawValue))
            }
        case .board:
            do {
                try Board.run(parser, facade: facade)
            } catch {
                throw Root.Error(inner: error, usage: List.Board.usageDescriptionAndOptions(command.rawValue))
            }
        case .status:
            do {
                try Status.run(parser, facade: facade)
            } catch {
                throw Root.Error(inner: error, usage: List.Status.usageDescriptionAndOptions(command.rawValue))
            }
        case .epic:
            do {
                try Epic.run(parser, facade: facade)
            } catch {
                throw Root.Error(inner: error, usage: List.Epic.usageDescriptionAndOptions(command.rawValue))
            }
        }
    }

    enum Command: String, CommandList {
        case board
        case epic
        case field
        case sprint
        case status
    }
}
