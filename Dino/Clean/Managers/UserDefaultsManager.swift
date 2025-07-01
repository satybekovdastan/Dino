//
//  UserDefaultsManager.swift
//  Jorgo
//
//  Created by DAS on 2/6/21.
//  Copyright © 2021 Doit. All rights reserved.
//

import Foundation

protocol UserDefaultsManager: AnyObject {
    
    var token: String { get set}
    var refreshToken: String { get set}
    var fcmToken: String { get set}
    var rideId: Int { get set}
    var notificationTappedKey: [AnyHashable: Any] { get set}
    var introDate: String { get set}
    var createdRideTimeInMilliSeconds: Int { get set}
    var timeoutIntervalForRequest: TimeInterval { get set }
    var searchDriverTimer: Int { get set}
    var isWelcomeWidgetShowed: Bool { get set}
    var debt: String { get set}
    var location: String { get set}
    var deeplinkPromocode: String { get set}
    var cacheHasBeenChecked: Bool { get set }
    var languageCode: String? { get }
    var hasKaspiAlertRead: Bool { get set }
    
    func setSearchDriverTimer(timer: Int?)
    
}

final class DefaultUserDefaultsManager: UserDefaultsManager {
    func setSearchDriverTimer(timer: Int?) {
        
    }
    
    
    static let shared = DefaultUserDefaultsManager()
    
    private init() {}

    private enum UserDefaultsKeys {
        static let tokenKey = "token_key_jorgo"
        static let refreshTokenKey = "refresh_token_key_nasolist"
        static let rideIdKey = "key_ride_id"
        static let fcmToken = "fcmToken"
        static let notificationTappedKey = "notificatioTappedKey"
        static let debt = "debt"
        static let searchDriverTimer = "searchDriverTimer"
        static let createdRideTimeInMilliSeconds = "createdRideTimeInMilliSeconds"
        static let isWelcomeWidgetShowed = "isWelcomeWidgetShowed"
        static let location = "location"
        static let introDate = "introDate"
        static let cacheHasBeenChecked = "cache_has_been_checked"
        static let deeplinkPromocode = "deeplinkPromocode"
        static let hasKaspiAlertRead = "hasKaspiAlertRead"
        static let timeoutIntervalForRequest = "timeoutIntervalForRequest"
    }
    
    @UserDefault(UserDefaultsKeys.tokenKey, defaultValue: "")
    var token: String
    
    @UserDefault(UserDefaultsKeys.refreshTokenKey, defaultValue: "")
    var refreshToken: String
    
    @UserDefault(UserDefaultsKeys.fcmToken, defaultValue: "")
    var fcmToken: String
    
    @UserDefault(UserDefaultsKeys.rideIdKey, defaultValue: -1)
    var rideId: Int
    
    @UserDefault(UserDefaultsKeys.notificationTappedKey, defaultValue: ["": ""])
    var notificationTappedKey: [AnyHashable: Any]
    
    @UserDefault(UserDefaultsKeys.introDate, defaultValue: "")
    var introDate: String
    
    @UserDefault(UserDefaultsKeys.createdRideTimeInMilliSeconds, defaultValue: 0)
    var createdRideTimeInMilliSeconds: Int
    
    @UserDefault(UserDefaultsKeys.timeoutIntervalForRequest, defaultValue: TimeInterval(truncating: 30))
    var timeoutIntervalForRequest: TimeInterval
    
    @UserDefault(UserDefaultsKeys.searchDriverTimer, defaultValue: 300)
    var searchDriverTimer: Int
    
    @UserDefault(UserDefaultsKeys.isWelcomeWidgetShowed, defaultValue: false)
    var isWelcomeWidgetShowed: Bool
    
    @UserDefault(UserDefaultsKeys.debt, defaultValue: "")
    var debt: String
    
    @UserDefault(UserDefaultsKeys.location, defaultValue: "")
    var location: String
    
    @UserDefault(UserDefaultsKeys.deeplinkPromocode, defaultValue: "")
    var deeplinkPromocode: String
    
    
    @UserDefault(UserDefaultsKeys.cacheHasBeenChecked, defaultValue: false)
    var cacheHasBeenChecked: Bool
    
    var languageCode: String? {
        UserDefaults.standard
            .stringArray(forKey: "AppleLanguages")?
            .first?
            .components(separatedBy: "-")
            .first
    }
    
    @UserDefault(UserDefaultsKeys.hasKaspiAlertRead, defaultValue: false)
    var hasKaspiAlertRead: Bool
}


@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

