//
//  BodyParameter.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

protocol BodyParameter {
    func data() throws -> Data
}

struct EncodableBodyParameter<T: Encodable>: BodyParameter {
    private let encodable: T

    init(encodable: T) {
        self.encodable = encodable
    }

    func data() throws -> Data {
        return try JSONEncoder().encode(encodable)
    }
}

struct DictionaryBodyParameter: BodyParameter {
    private let dictionary: [String: Any]
    private let options: JSONSerialization.WritingOptions

    init(dictionary: [String: Any], options: JSONSerialization.WritingOptions = []) {
        self.dictionary = dictionary
        self.options = options
    }

    func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: dictionary, options: options)
    }
}
