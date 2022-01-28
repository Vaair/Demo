//
//  MoonCalc.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import CoreLocation

/// Calculator
public class MoonCalc {

    /// Location
    private let location: CLLocation
    
    private let moonAgeCalculator: MoonAgeCalculatorProtocol  = MoonAgeCalculator()
    
    private let moonZodiaSignCalculator: MoonZodiacSignCalculatorProtocol = MoonZodiacSignCalculator()
    
    private lazy var moonRiseSetCalculator: MoonRiseSetCalculatorProtocol = MoonRiseSetCalculator(location: location)
    
    private lazy var moonPhaseCalculator: MoonPhaseCalculatorProtocol = MoonPhaseCalculator(moonAgeCalculator: moonAgeCalculator)
    
    private lazy var moontrajectoryCalculator: MoonTrajectoryCalculatorProtocol = MoonTrajectoryCalculator(moonAgeCalculator: moonAgeCalculator)

    // MARK: - Init
    
    public init(location: CLLocation) {
        self.location = location
    }

    /// get information by date
    /// - Parameter date: current date
    /// - Returns: Astrology model
    public func getInfo(date: Date) -> AstroModel {
        
        let phase = moonPhaseCalculator.getMoonPhase(date: date)

        let trajectory = moontrajectoryCalculator.getMoonTrajectory(date: date)
        let moonModels = getMoonModels(date: date)

        let illumination = try? SunMoonCalculator(date: date, location: location).getMoonIllumination(date: date)
        let astrologyModel = AstroModel(
            date: date,
            location: location,
            trajectory: trajectory,
            phase: phase,
            moonModels: moonModels,
            illumination: illumination
        )
        return astrologyModel
    }
    
}

// MARK: - Private

extension MoonCalc {

    // Получить модели лунного дня для текущего человеческого дня
    private func getMoonModels(date: Date) -> [MoonModel] {
        let startDate = date.startOfDay
        guard let endDate = date.endOfDay else { return [] }

        let ages = moonAgeCalculator.getMoonAges(date: date)
        let moonRise = try? moonRiseSetCalculator.getMoonRise(date: startDate).get()
        let moonSet = try? moonRiseSetCalculator.getMoonSet(date: endDate).get()
        let zodiacSignStart = moonZodiaSignCalculator.getMoonZodicaSign(date: startDate)
        let zodiacSignEnd = moonZodiaSignCalculator.getMoonZodicaSign(date: endDate)

        let prevStartDay = startDate.adjust(.day, offset: -1).startOfDay
        let nextEndDate = endDate.adjust(.day, offset: 1).endOfDay!

        let prevMoonRise = try? moonRiseSetCalculator.getMoonRise(date: prevStartDay).get()
        var nextMoonRise = try? moonRiseSetCalculator.getMoonRise(date: nextEndDate).get()

        if ages.count < 1 {
            return []
        } else if ages.count == 1 {
            let model = MoonModel(age: ages[0], sign: zodiacSignEnd, begin: prevMoonRise, finish: nextMoonRise)
            return [model]
        } else if ages.count == 2 {

            if (moonSet?.timeIntervalSince1970 ?? 0) < (nextMoonRise?.timeIntervalSince1970 ?? 0) && (moonSet?.timeIntervalSince1970 ?? 0) > (moonRise?.timeIntervalSince1970 ?? 0) {
                nextMoonRise = try? moonRiseSetCalculator.getMoonRise(date: endDate).get()
            }

            let model1 = MoonModel(age: ages[0], sign: zodiacSignStart, begin: prevMoonRise, finish: moonRise)
            let model2 = MoonModel(age: ages[1], sign: zodiacSignEnd, begin: moonRise, finish: nextMoonRise)
            return [model1, model2]
        } else if ages.count == 3 {
            if (moonSet?.timeIntervalSince1970 ?? 0) < (nextMoonRise?.timeIntervalSince1970 ?? 0) && (moonSet?.timeIntervalSince1970 ?? 0) > (moonRise?.timeIntervalSince1970 ?? 0) {
                nextMoonRise = try? moonRiseSetCalculator.getMoonRise(date: endDate).get()
            }

            let middleZodiacSign = (zodiacSignStart == zodiacSignEnd) ? zodiacSignStart : zodiacSignEnd
            let model1 = MoonModel(age: ages[0], sign: zodiacSignStart, begin: prevMoonRise, finish: moonRise)
            let model2 = MoonModel(age: ages[1], sign: middleZodiacSign, begin: moonRise, finish: moonSet)
            let model3 = MoonModel(age: ages[2], sign: zodiacSignEnd, begin: moonSet, finish: nextMoonRise)
            return [model1, model2, model3]
        } else {
            return []
        }
    }
}
