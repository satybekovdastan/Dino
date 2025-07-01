//
//  UserRouter.swift
//  Navi
//
//  Created by DAS  on 8/3/23.
//  Copyright © 2023 Doit. All rights reserved.
//


import UIKit
import Alamofire
import Swinject

enum UserRouter: APIConfiguration {
    
    private static let userDefaultsManager: UserDefaultsManager = {
        Assembler.shared.resolver.resolve(UserDefaultsManager.self)!
    }()
    
    case loginSendCode(phone: String)
    case verifyCode(phone: String, code: String, uiDevice: String, deviceModel: String, deviceVersion: String, language: String)
    case getProfile
    case signUp(firstName: String, lastName: String)
    case refreshTokenWithCompletion
    case updateFCM
    case deleteProfile

    var method: HTTPMethod {
        switch self {
        case .loginSendCode:
            return .post
        case .verifyCode:
            return .post
        case .getProfile:
            return .get
       
        case .signUp:
            return .put
        case .refreshTokenWithCompletion:
            return .post
       
        case .updateFCM:
            return .patch
        case .deleteProfile:
            return .delete
    
        }
    }
    
    var path: String {
        let ridersProfileEndpoint = "api/v1/riders/profile/"
        switch self {
        case .loginSendCode:
            return "api/v1/auth/send_code/"
        case .verifyCode:
            return "api/v1/auth/riders/verify-code/"
        case .getProfile:
            return ridersProfileEndpoint
        case .signUp:
            return ridersProfileEndpoint
        case .refreshTokenWithCompletion:
            return "api/v1/auth/generate-tokens/"
       
        case .updateFCM:
            return "api/v1/riders/device-info/"
        case .deleteProfile:
            return ridersProfileEndpoint
       
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .loginSendCode(let phone):
            return ["phone" : phone]
        case .verifyCode(let phone, let code, let uiDevice, let deviceModel, let deviceVersion, _):
            var fcmToken = Self.userDefaultsManager.fcmToken
            if fcmToken.isEmpty {
                fcmToken = "e1rro6M8OkVxsEqRQDPefb:APA91bHiq2LgUbG-XvJe575ByGrxP06O3W1gxOd4X0gqN1khZ3m-XXePfoyOnr8O_w67ThzZI-CmUjlDAv8BrssWHeOpqyU37nq_E34NSb8VHtfZG-cXqrjXxIBa6o6D5diCYBpbCcbG"
            }
            var app_version = ""

            if let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                app_version = versionLocal
            }
                        
            var params = [
                "phone": phone,
//                "code": code,
//                "fcm_token": fcmToken,
//                "device": "ios",
//                "device_id": uiDevice,
//                "device_model": deviceModel,
//                "device_version": deviceVersion,
//                "app_version": app_version
            ] as [String : Any]

           
            
            return params
        case .getProfile:
            return nil
       
        case .signUp(firstName: let firstName, lastName: let lastName):
            return ["first_name": firstName,
                    "last_name": lastName,
                    "show_phone": "true"]
        case .refreshTokenWithCompletion:
            let refreshToken = Self.userDefaultsManager.refreshToken
            if refreshToken.isEmpty {
                LoginLogoutManager.logout()
                return nil
            }
            let params = ["refresh_token": refreshToken]
            return params
       
        case .updateFCM:
            let fcmToken = Self.userDefaultsManager.fcmToken
            if fcmToken.isEmpty {
                return nil
            }
           
            
            let params = [
                "fcm_token": fcmToken
            ] as [String : Any]
            
            return params
        case .deleteProfile:
            return nil
        }
    }
    
   
   func asURLRequest() throws -> URLRequest {
       let url = AppRequestConfigurations.baseURL
       
       let encodedPath = path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
       var urlRequest = URLRequest(url: URL(string: "\(url)\(encodedPath ?? "")") ?? URL(string: "www.google.com")!)
       
       // HTTP Method
       urlRequest.httpMethod = method.rawValue
       
       // Common Headers
       switch self {
       case .refreshTokenWithCompletion:
           urlRequest.setValue("Bearer \(Self.userDefaultsManager.refreshToken)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
       default:
           urlRequest.setValue("Bearer \(Self.userDefaultsManager.token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
       }
       
       urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

       urlRequest.setValue(Self.userDefaultsManager.languageCode, forHTTPHeaderField: HTTPHeaderField.acceptLanguage.rawValue)
    
       // Parameters
       if let parameters = parameters {
           do {
               urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
           } catch {
               throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
           }
       }
       
       return urlRequest
   }
   
   
}
