//
//  NSAttributedStringTransformer.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 23.11.2021.
//

import Foundation

@objc(NSAttributedStringTransformer)
class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [NSAttributedString.self]
    }
}
