//
//  BoardEntity.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/06.
//

public struct Board: ListableResponse {
    public static let key: String = "values"

    public let id: Int
    public let location: Location
    public let name: String
    public let `self`: String
    public let type: String
}

public enum Location: Codable {
    case project(Project)
    case user(User)

    public struct Project: Codable {
        public let avatarURI: String
        public let name: String
        public let projectId: Int
        public let projectTypeKey: String
    }

    public struct User: Codable {
        public let avatarURI: String
        public let name: String
        public let userId: Int
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .project(try container.decode(Project.self))
        } catch {
            self = .user(try container.decode(User.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .project(let value):
            try container.encode(value)
        case .user(let value):
            try container.encode(value)
        }
    }
}

extension Location {
    public var project: Project? {
        if case .project(let value) = self {
            return value
        }
        return nil
    }

    public var user: User? {
        if case .user(let value) = self {
            return value
        }
        return nil
    }
}
