//
//  Notifications.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static func sendNotifications(title: String, message: String, type: NotificationType) {
      let content = UNMutableNotificationContent()
      content.title = title
      content.body = message
      content.sound = UNNotificationSound.default
      content.badge = 1
      UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: type.rawValue, content: content, trigger: nil)) { (error) in
         // //print(error)
      }
   }
}
