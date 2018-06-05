//
//  ListResponse.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

import Foundation

protocol ListableResponse: Decodable {
    static var key: String { get }
}

struct ListResponse<T: ListableResponse> {
    let expand: String
    let total: Int
    let maxResults: Int
    let startAt: Int
    let values: [T]
}

extension ListResponse: Decodable {
    fileprivate enum ValuesCodingKey {
        case key(String)
    }

    private enum CodingKeys: String, CodingKey {
        case expand
        case total
        case maxResults
        case startAt
    }

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.expand = try container.decode(String.self, forKey: .expand)
            self.total = try container.decode(Int.self, forKey: .total)
            self.maxResults = try container.decode(Int.self, forKey: .maxResults)
            self.startAt = try container.decode(Int.self, forKey: .startAt)
        }

        do {
            let container = try decoder.container(keyedBy: ValuesCodingKey.self)
            self.values = try container.decode([T].self, forKey: .key(T.key))
        }
    }
}

extension ListResponse.ValuesCodingKey: CodingKey {
    var stringValue: String {
        if case .key(let value) = self {
            return value
        }
        fatalError("ListResponse.ValuesCodingKey does not have other cases.")
    }

    init?(stringValue: String) {
        self = .key(stringValue)
    }

    var intValue: Int? {
        return nil
    }

    init?(intValue: Int) {
        return nil
    }
}

