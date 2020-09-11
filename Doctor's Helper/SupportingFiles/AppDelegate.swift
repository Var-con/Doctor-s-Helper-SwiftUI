//
//  AppDelegate.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAutorezation()
        notificationCenter.delegate = self
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func requestAutorezation() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("\(settings)")
        }
    }
    
    func scheduleNotification(with list: ListOfUnworking) {
        
        let content = UNMutableNotificationContent()
        
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.title = "Не забудьте продлить л/н №\(list.listNumber)"
        var triggerDate = Calendar.current.dateComponents([.day, .calendar], from: list.endDate)
        triggerDate.hour = 10
        triggerDate.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = "Local Notification \(list.listNumber)"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
    
}

