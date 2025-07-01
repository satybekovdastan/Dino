//
//  BaseRepository.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 18/03/2021.
//

import Foundation

class BaseRepository {
    
    private func getCurrentTime() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    func getLasCall(key: LastCallKey) -> Int {
        
        let preferences = UserDefaults.standard
        if preferences.string(forKey: key.rawValue) != nil {
            let value = preferences.integer(forKey: key.rawValue)
            return value
        } else {
            return 0
        }
    }
    
    func saveLasCall(key: LastCallKey) {
        
        let preferences = UserDefaults.standard
        let currentTime = Int(Date().timeIntervalSince1970)
        
        preferences.set(currentTime, forKey: key.rawValue)
    }
    
    /// Проверяет, прошел ли заданный интервал времени с последнего вызова.
    /// - Parameter key: Ключ для получения времени последнего вызова.
    /// - Parameter interval: Интервал времени в секундах.
    /// - Returns: `true`, если прошло больше `interval` секунд с последнего вызова; `false` в противном случае.
    func canMakeCall(for key: LastCallKey, interval: Int) -> Bool {
        let currentTime = getCurrentTime() // Получаем текущее время
        let lastCallTime = getLasCall(key: key) // Получаем время последнего вызова
        let intervalTime = currentTime - lastCallTime // Вычисляем интервал времени
        
        guard intervalTime > interval else { return false } // Проверяем интервал времени
        
        // Если интервал времени больше, обновляем время последнего вызова
        saveLasCall(key: key)
        return true // Разрешаем вызов
    }
    
}

final class CallRateLimiter: BaseRepository {
    
    static let shared = CallRateLimiter()
    
}

enum LastCallKey : String {
    
    case lastCallPoll
    case lastCallPosts
    case lastCallUsers
    
    /// ViewModel
    case lastCallActiveRides

}

