//
//  AstroModel.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import CoreLocation

/// Model with all information
///
/// - date: Date, ect 01.01.1970
/// - location: CLLocation
/// - trajectory: MoonTrajectory
/// - phase: MoonPhase
/// - moonModels: [MoonModel]
/// - nextLunarEclipse
/// - previousLunarEclipse
/// - illumination: Illumination?
/// - solar: Solar // sunset and sunrize
public class AstroModel {

    /// дата обычная, например 01.01.1970
    public var date: Date = Date()

    /// гео позиция
    public var location: CLLocation

    /// траектория луны
    public var trajectory: MoonTrajectory

    /// фаза луны
    public var phase: MoonPhase

    /// модель лунных дней для даты
    public var moonModels: [MoonModel]

    public let illumination: Illumination?

    public let solar: SunModel?


    init(date: Date, location: CLLocation, trajectory: MoonTrajectory, phase: MoonPhase, moonModels: [MoonModel], illumination: Illumination?) {
        self.date = date
        self.location = location
        self.trajectory = trajectory
        self.phase = phase
        self.moonModels = moonModels
        self.illumination = illumination
        self.solar = SunCalculator(for: date, coordinate: location.coordinate)?.getSolar()
    }
}
