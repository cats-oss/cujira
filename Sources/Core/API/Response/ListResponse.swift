//
//  ListResponse.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/05.
//

public protocol ListableResponse: Decodable {
    static var key: String { get }
}

public struct ListResponse<T: ListableResponse> {
    public let expand: String?
    public let isLast: Bool?
    public let total: Int?
    public let maxResults: Int
    public let startAt: Int
    public let values: [T]
}

extension ListResponse: Decodable {
    fileprivate struct ValuesCodingKey: CodingKey {
        var stringValue: String
    }

    private enum CodingKeys: String, CodingKey {
        case expand
        case isLast
        case total
        case maxResults
        case startAt
    }

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.expand = try container.decodeIfPresent(String.self, forKey: .expand)
            self.isLast = try container.decodeIfPresent(Bool.self, forKey: .isLast)
            self.total = try container.decodeIfPresent(Int.self, forKey: .total)
            self.maxResults = try container.decode(Int.self, forKey: .maxResults)
            self.startAt = try container.decode(Int.self, forKey: .startAt)
        }

        do {
            let container = try decoder.container(keyedBy: ValuesCodingKey.self)
            self.values = try container.decode([T].self, forKey: ValuesCodingKey(stringValue: T.key))
        }
    }
}

extension ListResponse.ValuesCodingKey {
    var intValue: Int? {
        return Int(stringValue)
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
    }
}
