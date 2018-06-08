//
//  DateFormatter.core.swift
//  Core
//
//  Created by marty-suzuki on 2018/06/08.
//

import Foundation

extension DateFormatter: CoreCompatible {}

extension CoreExtension where Base == DateFormatter {
    public static var yyyyMMdd: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }
}
