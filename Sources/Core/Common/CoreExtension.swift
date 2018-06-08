//
//  CoreExtension.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

public protocol CoreCompatible {
    associatedtype Base = Self
    static var core: CoreExtension<Base>.Type { get }
    var core: CoreExtension<Base> { get }
}

extension CoreCompatible {
    public static var core: CoreExtension<Self>.Type {
        return CoreExtension<Self>.self
    }

    public var core: CoreExtension<Self> {
        return CoreExtension(base: self)
    }
}

public struct CoreExtension<Base> {
    let base: Base
}
