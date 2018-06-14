//
//  AnyCodingKey.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/14.
//

import Foundation

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
