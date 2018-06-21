//
//  Gap.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/21.
//

import Foundation

#if swift(>=4.1)
// nothing
#else
extension Sequence {
    public func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try flatMap(transform)
    }
}
#endif
