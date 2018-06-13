//
//  BodyParameter.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

public protocol BodyParameter {
    func data() throws -> Data
}

public struct EncodableBodyParameter<T: Encodable>: BodyParameter {
    let encodable: T

    public init(encodable: T) {
        self.encodable = encodable
    }

    public func data() throws -> Data {
        return try JSONEncoder().encode(encodable)
    }
}

public struct DictionaryBodyParameter: BodyParameter {
    let dictionary: [String: Any]
    let options: JSONSerialization.WritingOptions

    public init(dictionary: [String: Any], options: JSONSerialization.WritingOptions = []) {
        self.dictionary = dictionary
        self.options = options
    }

    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: dictionary, options: options)
    }
}
