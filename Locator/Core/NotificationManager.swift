//
//  NotificationManager.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 23.11.2021.
//

import UserNotifications

final class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private var notificationGranted : Bool?
    
    private override init() {
        super.init()
    }
    
    func configureNotificationManager() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                self.notificationGranted = false
                return
            }

            self.notificationGranted = true
        }
    }
    
    
    func makeNotificationContent(title: String,
                                 subtitle: String,
                                 body: String,
                                 badge : NSNumber?) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        return content
    }
    
    func makeIntervalNotificationTrigger(timeInterval: TimeInterval, repeats: Bool) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                 repeats: repeats
        )
    }
    
    func sendNotificationRequest(content: UNNotificationContent,
                                 trigger: UNNotificationTrigger,
                                 id: String) {
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        let center = UNUserNotificationCenter.current()
        guard notificationGranted ?? false else { return }
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeReturnToAppNotification() {
        let content = makeNotificationContent(title: "Locator",
                                              subtitle: "Долгое бездействие",
                                              body: "Пожалуйста, возвращайтесь в приложение",
                                              badge: nil)
        let trigger = makeIntervalNotificationTrigger(timeInterval: 10,
                                                    repeats: false)
        let id = "returnToAppNotification_ID"
        sendNotificationRequest(content: content,
                                trigger: trigger,
                                id: id)
    }
}
