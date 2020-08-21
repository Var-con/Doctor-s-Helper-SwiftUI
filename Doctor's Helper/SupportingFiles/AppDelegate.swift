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

    let notificationCente = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAutorezation()
        scheduleNotification()
        notificationCente.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func requestAutorezation() {
        notificationCente.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission grnted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCente.getNotificationSettings { (settings) in
            print("\(settings)")
        }
    }
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let lists = ListsOfUnworking().fetchLists()
        for (index, list) in lists.enumerated() {
            content.title = "Не забудьте продлить л/н №\(list.listNumber)"
            let date = list.endDate
            let triggerDate = Calendar.current.dateComponents(in: .current, from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let identifier = "Local Notification \(index)"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            
            notificationCente.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
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

}

