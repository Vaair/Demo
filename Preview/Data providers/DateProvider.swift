//
//  DateProvider.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 24.07.2021.
//

import Foundation

class DateProvider {
    
    static func getDateDifDay(days: Int) -> Date{
        let now = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + days)
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: tomorrow) ?? Date()
    }
    
    static func getDateDif(date: Date = Date(),
                           years: Int = 0,
                           months: Int = 0,
                           days: Int = 0) -> Date{
        let dateComponent = Calendar.current.dateComponents(in: .current, from: date)
        guard let yearNow = dateComponent.year,
              let monthNow = dateComponent.month,
              let dayNow = dateComponent.day else {return Date()}
        
        var neededDateComponent: DateComponents
            neededDateComponent = DateComponents(year: yearNow + years,
                                                 month: monthNow + months,
                                                 day: dayNow + days)
        return Calendar.current.date(from: neededDateComponent) ?? Date()
    }
    
    static func getShortDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        return dateFormatter.string(from: date) 
    }
    
    static func dateNow(date: Date) -> String{
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "Ru_ru")
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    static func serverTimeReturn(completionHandler: @escaping (Date?) -> ()){
        guard let url = URL(string: "https://www.apple.com") else {completionHandler(nil); return}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if data == nil {
                completionHandler(nil)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {completionHandler(Date()); return}
            if let contentType = httpResponse.allHeaderFields["Date"] as? String {
                let dFormatter = DateFormatter()
                dFormatter.locale = Locale(identifier: "en_US_POSIX")
                dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
                guard let serverTime = dFormatter.date(from: contentType) else {completionHandler(Date()); return}
                completionHandler(serverTime)
            }
        }
        
        task.resume()
    }
}
