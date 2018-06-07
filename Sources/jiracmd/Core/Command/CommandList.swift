//
//  CommandList.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/07.
//

protocol CommandList: Enumerable {
    static var usageDescription: String { get }
    init?(rawValue: String)
}
