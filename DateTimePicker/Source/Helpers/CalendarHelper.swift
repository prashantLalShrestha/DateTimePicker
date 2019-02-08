//
//  CalendarHelper.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import Foundation

class CalendarHelper {
    
    static func fetchYears(startYear: Int, endYear: Int) -> [String] {
        let cal = Calendar.current
        var years:[String] = []
        let StartDateComponents = DateComponents(year: startYear , month: 1, day: 1)
        
        guard let startDate = cal.date(from: StartDateComponents) else {
            return []
        }
        if endYear > startYear {
            let range = endYear - startYear
            for i in 0 ... range {
                guard let yearsBetween = cal.date(byAdding: .year, value: i, to: startDate) else { return [] }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: yearsBetween)
                years.append(year)
            }
            return years
        }else {
            fatalError("startYear cannot be greater than EndYear")
        }
        
    }
    
    static func fetchDays(_ years: [ModelDate], _ months: [ModelDate]) -> Int {
        var numDays = 0
        var currentMonth = "6"
        for (index, month) in months.enumerated() {
            if month.isSelected == true {
                currentMonth = "\(index + 1)"
                break
            }
        }
        if let yearInt = Int(years.currentYear.type), let monthInt = Int(currentMonth){
            let dateComponents = DateComponents(year: yearInt, month: monthInt)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            //            print(date)
            let range = calendar.range(of: .day, in: .month, for: date)!
            numDays = range.count
        }
        return numDays
    }
    
    
    static func getThatDate(_ days: [ModelDate], _ months: [ModelDate], _ years: [ModelDate]) -> Date{
        var currentDay: String = ""
        var currentMonth: String = ""
        var currentYear: String = ""
        for day in days{
            if day.isSelected == true {
                currentDay = day.type
                break
            }
        }
        for month in months {
            if month.isSelected == true {
                currentMonth = month.type
                break
            }
        }
        for year in years {
            if year.isSelected == true {
                currentYear = year.type
                break
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: "\(currentMonth)/\(currentDay)/\(currentYear)")
        
        return date!
    }
    
    static func getThatTime(_ hours: [ModelDate], _ minutes: [ModelDate]) -> Date{
        var currentHour: String = ""
        var currentMinute: String = ""
        for hour in hours{
            if hour.isSelected == true {
                currentHour = hour.type
                break
            }
        }
        for minute in minutes {
            if minute.isSelected == true {
                currentMinute = minute.type
                break
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: "\(currentHour):\(currentMinute)")
        
        return date!
    }
}

extension Array where Element: ModelDate {
    
    var currentMonth: ModelDate {
        if let selectedMonth = self.filter({ (modelObject) -> Bool in
            return modelObject.isSelected
        }).first {
            return selectedMonth
        }
        return ModelDate(type: "6", isSelected: false)
    }
    
    var currentYear: ModelDate {
        if let selectedYear = self.filter({ (modelObj) -> Bool in
            return modelObj.isSelected
        }).first {
            return selectedYear
        }
        return ModelDate(type: "2006", isSelected: false)
    }
    
    func selectDay(selectedDay: ModelDate){
        for day in self  {
            if day == selectedDay {
                day.isSelected = selectedDay.isSelected
            }
        }
    }
}
