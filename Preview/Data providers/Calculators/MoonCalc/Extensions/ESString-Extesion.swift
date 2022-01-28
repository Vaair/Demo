//
//  String+Extension.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import Foundation

public extension String {
    
    func toDate(fromFormat: DateFormatType) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat.stringFormat
        return formatter.date(from: self)
    }
    
}
