//
//  DataProvider.swift
//  Preview
//
//  Created by Лера Тарасенко on 28.01.2022.
//

import Foundation

final class DataProvider{
    static func getDateInfo(date: Date) -> AstroViewModel?{
        do{
            let smc:SunMoonCalculator1 = try SunMoonCalculator1(date: date,
                                                                longitude: UDDatabase.longitude,
                                                                latitude: UDDatabase.latitute)
            smc.calcSunAndMoon()
            return AstroViewModel(model: smc, date: date)
        } catch{
            print("")
            return nil
        }
    }
}
