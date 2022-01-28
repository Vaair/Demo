//
//  MoonPhaseCalculator.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import Foundation

public protocol MoonPhaseCalculatorProtocol {
    
    func getMoonPhase(date: Date) -> MoonPhase
    
}

public final class MoonPhaseCalculator {
    
    private let moonAgeCalculator: MoonAgeCalculatorProtocol
    
    public init(moonAgeCalculator: MoonAgeCalculatorProtocol) {
        self.moonAgeCalculator = moonAgeCalculator
    }
    
}

// MARK: - MoonPhaseCalculatorProtocol

extension MoonPhaseCalculator: MoonPhaseCalculatorProtocol {
    
    ///Получить фазу луны
    public func getMoonPhase(date: Date) -> MoonPhase {
        let age: Double = moonAgeCalculator.getMoonAge(date: date)
        
        var phase: MoonPhase
        
        if (age < 1.84566) {
            phase = .newMoon
        } else if (age < 5.53699) {
            phase = .waxingCrescent
        } else if (age < 9.22831) {
            phase = .firstQuarter
        } else if (age < 12.91963) {
            phase = .waxingGibbous
        } else if (age < 16.61096) {
            phase = .fullMoon
        } else if (age < 20.30228) {
            phase = .waningGibbous
        } else if (age < 23.99361) {
            phase = .lastQuarter
        } else if (age < 27.68493) {
            phase = .waningCrescent
        } else {
            phase = .newMoon
        }
        
        return phase
    }
    
}
