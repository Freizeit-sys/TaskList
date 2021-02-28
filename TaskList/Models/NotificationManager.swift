//
//  NotificationManager.swift
//  TaskList
//
//  Created by Admin on 2021/02/28.
//

import UIKit

class NotificationManager {
    
    private let calendarManager = CalendarManager()
    private let center = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("allow.")
            } else {
                print("did not allow.")
            }
        }
    }
    
    func setNotifications() {
        // Remove all notifications
        center.removeAllPendingNotificationRequests()
        
        var dateComponents = DateComponents()
        let content = UNMutableNotificationContent()
        
        let datasource = TaskListsDataSource()
        let taskLists = datasource.getTaskLists()
        
        for taskList in taskLists {
            for task in taskList.tasks {
                // Set duedate
                let duedate = task.duedate
                dateComponents.calendar = calendarManager.calendar
                dateComponents.timeZone = calendarManager.calendar.timeZone
                dateComponents.year = duedate.year
                dateComponents.month = duedate.month
                dateComponents.day = duedate.day
                dateComponents.hour = duedate.hour
                dateComponents.minute = duedate.minute
                
                // Set content
                content.title = ""
                content.body = task.title
                content.sound = .default
                
                // Set notfification
                let identifier = UUID().uuidString
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
//    // Debug
//    func test() {
//        for i in 1...3 {
//            let content = UNMutableNotificationContent()
//            content.title = "Test"
//            content.body = "Notification \(i)"
//            content.sound = .none
//            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(1 + (1 * i)), repeats: false)
//            let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request)
//        }
//    }
    
}
