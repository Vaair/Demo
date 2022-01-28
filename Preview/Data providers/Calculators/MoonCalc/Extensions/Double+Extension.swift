//
//  Double+Extension.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import Foundation

internal extension Double {
    //нормализовать число, т.е. число от 0 до 1
    var normalized: Double {
        var v = self - floor(self)
        if (v < 0) {
            v = v + 1
        }
        return v
    }
}
