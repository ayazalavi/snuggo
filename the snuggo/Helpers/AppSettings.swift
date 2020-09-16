//
//  Data.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/7/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

enum KEYS: String, RawRepresentable {
    case PRODUCTS
}

enum BluetoothServices: String, Codable, CodingKey {
    case UUID = ""
}

enum NotificationType: String, RawRepresentable {
    case NO_BLUETOOTH_NOTIFICATION
    case CHILD_LEFT_IN, CHILD_LEFT_SEAT
    case SEAT_BELT, WEIGHT, TEMPERATURE
}

class AppSettings: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = AppSettings()
    
    private override init() {}
    
    var start: Bool {
        checkForNotifications { settings in
            if settings.authorizationStatus != .authorized {
                self.requestNotifications
            } else {
                UNUserNotificationCenter.current().delegate = self
            }
            
        }
        return true
    }
    
    var requestNotifications: Void {
        if #available(iOS 12.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { (allowe, error) in
                //print(allowe, error ?? "error-str")
            }
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allowe, error) in
                //print(allowe, error ?? "error-str")
            }
            // Fallback on earlier versions
        }
    }
    
    func checkForNotifications(callback: @escaping (UNNotificationSettings) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            callback(settings)
        }
    }
    
    // MARK: Notification delegates
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //print("did receive")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("will present")
        completionHandler(.alert)
        if notification.request.identifier == NotificationType.NO_BLUETOOTH_NOTIFICATION.rawValue {
            UIApplication.shared.open(URL(string: "App-Prefs:root=Bluetooth")!, options: [.universalLinksOnly: false], completionHandler: nil)

        }
    }
    
    
}
