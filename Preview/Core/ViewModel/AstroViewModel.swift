//
//  AstroViewModel.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 02.08.2021.
//

import UIKit
import CoreLocation

protocol AstroViewModelProtocol: AnyObject {
    var date: Date { set get }
    var numberMoonDay: Int {get}
    var sign: MoonZodiacSign {get}
    var phase: MoonPhase {get}
    func getPhaseImage() -> UIImage
    var fraction: Double? {get}
    var moonset: String{get}
    var moonrise: String{get}
    var nextMoonrise: String {get}
    
    var sunset: String{get}
    var sunrise: String{get}
    
    func getStartDate() -> String
    func getRawStartDate() -> Date
    func getTime() -> String
    func getFinishDate() -> String
    func getRawFinishtDate() -> Date
    
    func getStatusMoon() -> String
}

class AstroViewModel: AstroViewModelProtocol {
    private var model: SunMoonCalculator1
    
    var date: Date
    
    var numberMoonDay: Int {
        let cal = MoonCalc(location: CLLocation(latitude: UDDatabase.latitute,
                                                longitude: UDDatabase.longitude))
        let info = cal.getInfo(date: date)
        
        guard info.moonModels.count > 1 else {return 1}
        var number = info.moonModels[1]
        number.age += 1
        if getRawStartDate() <= (info.moonModels[0].begin ?? date) && getRawFinishtDate() >= (info.moonModels[0].finish ?? date){
            number = info.moonModels[0]
        }
        return number.age == 31 ? 2 : number.age
    }
    
    var sign: MoonZodiacSign {
        return model.moonSign(date: date)
    }
    
    var phase: MoonPhase {
        return model.moonPhase
    }
    
    var phaseString: String {
        var nameImage = ""
        switch phase {
        case .newMoon:
            nameImage = "newMoon"
        case .fullMoon:
            nameImage = "fullMoon"
        case .firstQuarter:
            nameImage = "firstQ"
        case .lastQuarter:
            nameImage = "lastQ"
        case .waningCrescent:
            nameImage = "fourPhase"
        case .waningGibbous:
            nameImage = "thirdPhase"
        case .waxingCrescent:
            nameImage = "firstPhase"
        case .waxingGibbous:
            nameImage = "secondPhase"
        }
        return nameImage
    }
    
    func getPhaseImage() -> UIImage{
        return UIImage(named: phaseString) ?? UIImage()
    }
    
    var fraction: Double? {
        return model.moonIllumination
    }
    
    var moonset: String{
        return getRawMoonsetDate().toHHmm
    }
    
    var moonrise: String{
        return getRawStartDate().toHHmm
    }
    
    var nextMoonrise: String{
        return getRawFinishtDate().toHHmm
    }
    
    var sunset: String{
        do{
            return try SunMoonCalculator1.getDate(jd: model.sunSet).toHHmm
        } catch {
            return ""
        }
    }
    
    var sunrise: String{
        do{
            return try SunMoonCalculator1.getDate(jd: model.sunRise).toHHmm
        } catch {
            return ""
        }
    }
    
    func getRawStartDate() -> Date{
        do{
            return try SunMoonCalculator1.getDate(jd: model.moonRise)
        } catch {
            return Date()
        }
    }
    
    func getRawMoonsetDate() -> Date{
        do{
            return try SunMoonCalculator1.getDate(jd: model.moonSet)
        }  catch {
            return Date()
        }
    }
    
    func getRawFinishtDate() -> Date{
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        do{
            let smc:SunMoonCalculator1 = try SunMoonCalculator1(date: nextDate,
                                                                longitude: UDDatabase.longitude,
                                                                latitude: UDDatabase.latitute)
            smc.calcSunAndMoon()
            return try SunMoonCalculator1.getDate(jd: smc.moonRise)
        } catch{
            return date
        }
    }
    
    func getStartDate() -> String{
        return DateProvider.getShortDate(date: getRawStartDate())
    }
    
    func getTime() -> String{
        return moonrise + " - " + nextMoonrise
    }
    
    func getFinishDate() -> String {
        return DateProvider.getShortDate(date: getRawFinishtDate())
    }
    
    func getStatusMoon() -> String{
        var status = ""
        switch phase {
        case .waxingCrescent, .firstQuarter, .waxingGibbous:
            status = "Растущая Луна"
        case .waningGibbous, .lastQuarter, .waningCrescent:
            status = "Убывающая Луна"
        case .newMoon, .fullMoon:
            status = "---"
        }
        return status
    }
    
    func getDateAsString(date:Date, utc:Bool? = false) -> String {
        var calendar:Calendar = Calendar.init(identifier: .gregorian)
        if utc! {
            calendar.timeZone = TimeZone.init(abbreviation: "UTC")!
        }
        let dc:DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return String(format: "%d/%02d/%02d %02d:%02d:%02d", dc.year!, dc.month!, dc.day!, dc.hour!, dc.minute!, dc.second!)
    }
    
    init(model: SunMoonCalculator1, date: Date) {
        self.model = model
        self.date = date
    }
}
