//
//  BDate.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import Foundation

class BDate {
    
    var month: String
    var day: String
    var year:String
    
    init(month: String, day: String, year:String) {
        self.month = month
        self.day = day
        self.year = year
    }
    
    class func getMonths() -> [String]{
        return ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
    }
    class func getYears(startYear: Int, endYear: Int) -> [String] {
        return CalendarHelper.fetchYears(startYear: startYear, endYear: endYear)
    }
    
}
