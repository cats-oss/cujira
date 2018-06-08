//
//  BoardEntity.swift
//  jiracmd
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

public enum Location: Decodable {
    case project(Project)
    case user(User)

    public struct Project: Decodable {
        public let avatarURI: String
        public let name: String
        public let projectId: Int
        public let projectTypeKey: String
    }

    public struct User: Decodable {
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
}
