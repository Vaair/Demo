//
//  MoonRiseSetCalculator.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import Foundation
import CoreLocation

public protocol MoonRiseSetCalculatorProtocol {
    
    func getMoonRise(date: Date) -> Result<Date, Error>
    func getMoonSet(date: Date) -> Result<Date, Error>
    
}

public final class MoonRiseSetCalculator {
    
    public enum ErrorReason: Error {
        case unableToFomDateFromComponents
    }
    
    private let location: CLLocation
    
    internal init(location: CLLocation) {
        self.location = location
    }

}

// MARK: - MoonRiseSetCalculatorProtocol

extension MoonRiseSetCalculator: MoonRiseSetCalculatorProtocol {
    
    ///Получить восход луны
    public func getMoonRise(date: Date) -> Result<Date, Error> {
        return getMoonRiseOrSet(date: date, isRise: true)
    }
    
    ///Получить заход луны
    public func getMoonSet(date: Date) -> Result<Date, Error> {
        return getMoonRiseOrSet(date: date, isRise: false)
    }
    
}

// MARK: - Private

extension MoonRiseSetCalculator {
    
    ///Получить восход/заход луны для лунного дня
    private func getMoonRiseOrSet(date: Date, isRise: Bool) -> Result<Date, Error> {
        do {
            let moonCalculator = try SunMoonCalculator(date: date, location: location)
            moonCalculator.calcSunAndMoon()
            var moonDateInt: [Int]
            if isRise {
                moonDateInt = try SunMoonCalculator.getDate(moonCalculator.moonRise)
            } else {
                moonDateInt = try SunMoonCalculator.getDate(moonCalculator.moonSet)
            }
            
            if let moonDate = getDateFromComponents(moonDateInt) {
                return .success(moonDate)
            } else {
                return .failure(ErrorReason.unableToFomDateFromComponents)
            }
            
        } catch {
            return .failure(error)
        }
    }
    
    ///Получить дату из кмпонент дня -- например [1970, 1, 1, 12, 24, 33] -> 01.01.1970 12:24:33
    private func getDateFromComponents(_ components: [Int]) -> Date? {
        
        var dateComponents = DateComponents()
        dateComponents.year = components[0]
        dateComponents.month = components[1]
        dateComponents.day = components[2]
        dateComponents.hour = components[3]
        dateComponents.minute = components[4]
        dateComponents.second = components[5]
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? calendar.timeZone
        let date = calendar.date(from: dateComponents)
        
        return date
    }
    
}
