//
//  CalendarManager.swift
//  TaskList
//
//  Created by Admin on 2021/02/27.
//

import Foundation

class CalendarManager {
    
    var currentMonthOfDates: [Date] = []
    var currentDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    let calendar = Date().calendar
    
    func daysAcquisition() -> Int {
        let numberOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth())!.count
        numberOfItems = numberOfWeeks * daysPerWeek
        return numberOfItems
    }
    
    func firstDateOfMonth() -> Date {
        return currentDate.firstDateOfMonth()
    }
    
    func ordinalityDay() -> Int {
        let ordinalityDay = calendar.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())!
        return ordinalityDay
    }
    
    func daysOfMonth() -> Int {
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let date = calendar.date(from: DateComponents(year: year, month: month))!
        let days = calendar.range(of: .day, in: .month, for: date)?.count
        return days!
    }
    
    func dateForCellAtIndexPath(numberOfItems: Int) {
        let ordinalityOfFirstDay = calendar.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        
        for i in 0 ..< numberOfItems {
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            
            let date = calendar.date(byAdding: dateComponents, to: firstDateOfMonth())!
            currentMonthOfDates.append(date)
        }
    }
    
    func date(at index: Int) -> Date {
        dateForCellAtIndexPath(numberOfItems: numberOfItems)
        return currentMonthOfDates[index]
    }
    
    func conversionDateFormat(indexPath: IndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems: numberOfItems)
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.item])
    }
}
