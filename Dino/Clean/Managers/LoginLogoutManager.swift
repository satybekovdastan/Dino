//
//  LoginLogoutManager.swift
//  Jorgo
//
//  Created by DAS on 2/6/21.
//  Copyright © 2021 Doit. All rights reserved.
//

import UIKit
import Swinject

final class LoginLogoutManager {
    
    private static let userDefaultsManager = Assembler.shared.resolver.resolve(UserDefaultsManager.self)!
    
    static func updateRootVC() {
        DispatchQueue.main.async {

//            guard let windowScene = UIApplication.shared.connectedScenes.first
//                    as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate
//            else { return }
                        
            if userDefaultsManager.token == "" {
                
//                if let authViewController = Assembler.shared.resolver.resolve(AuthVC.self) {
//                    sceneDelegate.window?.rootViewController = authViewController
//                }
//                sceneDelegate.window?.makeKeyAndVisible()
                
            } else {
//                StorageFileManager.shared.checkImage()
//
//                if UserManager.shared.isEmptyName() {
//                    if let vc = Assembler.shared.resolver.resolve(SignUpVC.self) {
//                        sceneDelegate.window?.rootViewController = vc
//                        sceneDelegate.window?.makeKeyAndVisible()
//                    }
//                } else {
//                    AppNetworkManager.shared.getDebts()
//                    AppNetworkManager.shared.fetchUser() { userResponse in
//                        if let languageCode = userDefaultsManager.languageCode,
//                           userResponse.language != userDefaultsManager.languageCode {
//                            AppNetworkManager.shared.changeLanguage(languageCode: languageCode)
//                        }
//                    }
//                    AppNetworkManager.shared.updateFCM()
//                    AnalyticsManager.shared.setUserID()
//                    if let sideMenuController = Assembler.shared.resolver.resolve(LGSideMenuController.self) {
//                        
//                        // 4. Set presentation style by your taste if you don't like the default one.
//                        sideMenuController.leftViewBackgroundBlurEffect = UIBlurEffect()
//                        sideMenuController.leftViewPresentationStyle = .slideAboveBlurred
//                        
//                        // 5. Set width for the left view if you don't like the default one.
//                        sideMenuController.leftViewWidth = 300
//                        sideMenuController.leftViewSwipeGestureArea = .full
//                        sideMenuController.isLeftViewSwipeGestureDisabled = true
////                        sideMenuController.addMenuSwipeGestureRecognizer()
//                        // 6. Make it `rootViewController` for your window.
//                        sceneDelegate.window?.rootViewController = sideMenuController
//                        sceneDelegate.window?.makeKeyAndVisible()
//                    }
//                }
            }
        }

    }

    static func logout() {
        userDefaultsManager.token = ""
        userDefaultsManager.refreshToken = ""
        resetDefaults()
   
        updateRootVC()
        getNewToken()
    }
    
    static func resetRideId(){
        userDefaultsManager.rideId = -1
    }
    
    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    static func getNewToken() {
//        Messaging.messaging().deleteData { error in
//            Messaging.messaging().token { token, error in
//                if error == nil {
//                    if let newToken = token {
//                        userDefaultsManager.fcmToken = newToken
//                    }
//                } else {
//                    userDefaultsManager.fcmToken = "e1rro6M8OkVxsEqRQDPefb:APA91bHiq2LgUbG-XvJe575ByGrxP06O3W1gxOd4X0gqN1khZ3m-XXePfoyOnr8O_w67ThzZI-CmUjlDAv8BrssWHeOpqyU37nq_E34NSb8VHtfZG-cXqrjXxIBa6o6D5diCYBpbCcbG"
//                }
//            }
//        }
//        
    }
    
}
