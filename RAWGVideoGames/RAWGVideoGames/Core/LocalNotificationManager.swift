//
//  localNotificationManager.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 12.12.2022.
//

import Foundation
import UserNotifications

enum VoidResult {
    case success
    case failure(Error)
}

extension VoidResult: Equatable {
    public static func == (lhs: VoidResult, rhs: VoidResult) -> Bool {
        return true
    }
}


enum LocalNotificationManagerError: Error {
    case notAuthorized
}

extension LocalNotificationManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "To use this feature you must enable notifications in settings".localized()
        }
    }
}

protocol NotificationProtocol {
    func scheduleNotification(title: String, message: String, id: UUID, date: Date, completion: @escaping (VoidResult) -> Void)
    func updateScheduledNotification(title: String, message: String,id: UUID, date: Date, completion: @escaping (VoidResult) -> Void)
    func deleteScheduledNotification(id: UUID,completion: @escaping (VoidResult) -> Void)
}

final class LocalNotificationManager: NotificationProtocol {
    static let shared = LocalNotificationManager()
    private let notificationCenter: UNUserNotificationCenter
    
    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }
    
    func scheduleNotification(title: String, message: String, id: UUID , date: Date, completion: @escaping (VoidResult) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async
            {
                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { (error) in
                        if error != nil {
                            completion(.failure(error!))
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    completion(.success)
                }
                else
                {
                    completion(.failure(LocalNotificationManagerError.notAuthorized))
                }
            }
        }
    }
    
    func updateScheduledNotification(title: String, message: String,id: UUID, date: Date, completion: @escaping (VoidResult) -> Void) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[id.uuidString])
        scheduleNotification(title: title, message: message, id: id, date: date) { result in
            return completion(result)
        }
    }
    
    func deleteScheduledNotification(id: UUID, completion: @escaping (VoidResult) -> Void) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        completion(.success)
    }
    
    
    
}
