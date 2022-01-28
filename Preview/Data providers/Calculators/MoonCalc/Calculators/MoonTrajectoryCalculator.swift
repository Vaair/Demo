//
//  MoonTrajectoryCalculator.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import Foundation

public protocol MoonTrajectoryCalculatorProtocol {
    
    func getMoonTrajectory(date: Date) -> MoonTrajectory
    
}

public final class MoonTrajectoryCalculator {
    
    private let moonAgeCalculator: MoonAgeCalculatorProtocol
    
    public init(moonAgeCalculator: MoonAgeCalculatorProtocol) {
        self.moonAgeCalculator = moonAgeCalculator
    }
    
}

// MARK: - MoonTrajectoryCalculatorProtocol

extension MoonTrajectoryCalculator: MoonTrajectoryCalculatorProtocol {
    
    ///Получить знак зодиака для дуны, траекторию луны, фазу луны
    public func getMoonTrajectory(date: Date) -> MoonTrajectory {
        let age: Double = moonAgeCalculator.getMoonAge(date: date)
        var trajectory: MoonTrajectory
        
        
        if (age < 1.84566) {
            trajectory = .ascendent
        } else if (age < 5.53699) {
            trajectory = .ascendent
        } else if (age < 9.22831) {
            trajectory = .ascendent
        } else if (age < 12.91963) {
            trajectory = .ascendent
        } else if (age < 16.61096) {
            trajectory = .descendent
        } else if (age < 20.30228) {
            trajectory = .descendent
        } else if (age < 23.99361) {
            trajectory = .descendent
        } else if (age < 27.68493) {
            trajectory = .descendent
        } else {
            trajectory = .ascendent
        }
        
        return trajectory
    }
    
}
