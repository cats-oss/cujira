//
//  Project.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/12.
//

import Foundation

public struct Project: Codable {
    let id: String
    let key: String
    let name: String
    let projectTypeKey: String
    let `self`: URL
}
