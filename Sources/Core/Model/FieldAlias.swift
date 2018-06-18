//
//  FieldAlias.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/18.
//

import Foundation

/// A field alias object.
public struct FieldAlias: Codable {

    ///
    public enum Name: String, Codable {
        case epiclink
        case storypoint
    }

    public let name: Name
    public let field: Field
}
