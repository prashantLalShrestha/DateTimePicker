//
//  ModelDate.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import Foundation



class ModelDate {
    
    
    var type:String
    var isSelected:Bool
    
    init(type:String, isSelected:Bool = false) {
        self.type = type
        self.isSelected = isSelected
    }
}

extension ModelDate: InfiniteScollingData {}

extension ModelDate {
    
    class func getMonths() -> [ModelDate]{
        let months = BDate.getMonths()
        
        var arrMonths:[ModelDate] = []
        for index in 0..<months.count {
            let x = ModelDate(type: months[index], isSelected: false)
            arrMonths.append(x)
        }
        return arrMonths
    }
    
    class func getYears(startYear: Int = 1980, endYear: Int = 2018) -> [ModelDate] {
        let years = BDate.getYears(startYear: startYear, endYear: endYear)
        
        var arrYears:[ModelDate] = []
        for index in 0..<years.count {
            arrYears.append(ModelDate(type: years[index], isSelected: false))
        }
        return arrYears
    }
    
    class func getDays(_ years:[ModelDate] , _ months: [ModelDate]) -> [ModelDate] {
        let days = CalendarHelper.fetchDays(years, months)
        //        print(ModelDate.dayUpTo(lastDayInt: days).map({ return $0.type }))
        return ModelDate.dayUpTo(lastDayInt: days)
    }
    
    class func getHours() -> [ModelDate] {
        return (0...23).map { (hourInt) -> ModelDate in
            return ModelDate(type: hourInt < 10 ? "0\(hourInt)" : "\(hourInt)")
        }
    }
    
    class func getMinutes() -> [ModelDate] {
        return (0...56).filter({ ($0 % 5) == 0 }).map { (minuteInt) -> ModelDate in
            return ModelDate(type: minuteInt < 10 ? "0\(minuteInt)" : "\(minuteInt)")
        }
    }
}

extension ModelDate {
    class func dayUpTo(lastDayInt: Int) -> [ModelDate] {
        return (1...lastDayInt).map { (dayInt) -> ModelDate in
            return ModelDate(type: "\(dayInt)")
        }
    }
}

extension ModelDate : Equatable {
    static func ==(lhs: ModelDate, rhs: ModelDate) -> Bool {
        return lhs.type == rhs.type
    }
}

extension Date{
    var seprateDateInDDMMYY : (String,String,String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let ArrDate = dateFormatter.string(from: self).components(separatedBy: "/")
        return (ArrDate[0],ArrDate[1],ArrDate[2])
    }
    
    var seprateDateInHHMM : (String,String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ArrDate = dateFormatter.string(from: self).components(separatedBy: ":")
        return (ArrDate[0],ArrDate[1])
    }
}
