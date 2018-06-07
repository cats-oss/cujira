//
//  BoardEntity.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/06.
//

struct Board: ListableResponse {
    static let key: String = "values"

    let id: Int
    let location: Location
    let name: String
    let `self`: String
    let type: String
}

enum Location: Decodable {
    case project(Project)
    case user(User)

    struct Project: Decodable {
        let avatarURI: String
        let name: String
        let projectId: Int
        let projectTypeKey: String
    }

    struct User: Decodable {
        let avatarURI: String
        let name: String
        let userId: Int
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .project(try container.decode(Project.self))
        } catch {
            self = .user(try container.decode(User.self))
        }
    }
}
