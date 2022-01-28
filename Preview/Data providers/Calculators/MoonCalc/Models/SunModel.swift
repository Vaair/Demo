//
//  File.swift
//  
//
//  Created by Emil Karimov on 02.06.2021.
//

import Foundation

public struct SunModel {

    public let sunrise: Date?
    public let sunset: Date?
    public let civilSunrise: Date?
    public let civilSunset: Date?
    public let nauticalSunrise: Date?
    public let nauticalSunset: Date?
    public let astronomicalSunrise: Date?
    public let astronomicalSunset: Date?

    public init(sunrise: Date?, sunset: Date?, civilSunrise: Date?, civilSunset: Date?, nauticalSunrise: Date?, nauticalSunset: Date?, astronomicalSunrise: Date?, astronomicalSunset: Date?) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.civilSunrise = civilSunrise
        self.civilSunset = civilSunset
        self.nauticalSunrise = nauticalSunrise
        self.nauticalSunset = nauticalSunset
        self.astronomicalSunrise = astronomicalSunrise
        self.astronomicalSunset = astronomicalSunset
    }

}
