//
//  NetworkRequestPerformer.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 21/03/2021.
//

import Alamofire
import OSLog
import UIKit

protocol NetworkRequestPerformer: AnyObject {
    var session: Session { get set }
    
    @discardableResult func performRequest<T:Decodable>(
        route: APIConfiguration,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) -> DataRequest
    @discardableResult func performUpload<T: Decodable>(
        route: APIConfiguration,
        imageData: Data,
        key: String?,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) -> DataRequest
}

final class DefaultNetworkRequestPerformer: NetworkRequestPerformer {
    
    // MARK: Properties
    
    var isRefreshingToken = false
    var pendingRequests: [AnyPendingRequest] = []
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Taxi",
        category: "Networking"
    )
    var session: Session = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return Session(configuration: configuration)
    }()
    
//    let userDefaultsManager = UserDefaultsManager()
    
    // MARK: Initialization
    
//    init(userDefaultsManager: UserDefaultsManager) {
//        self.userDefaultsManager = userDefaultsManager
//    }
    
    // MARK: Public Methods
    
    @discardableResult
    func performRequest<T:Decodable>(
        route: APIConfiguration,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) -> DataRequest {
        session.request(route).responseDecodable(of: T.self, decoder: decoder) { response in
            self.handleResponse(route: route, response: response, completion: completion)
        }
    }
    
    func performUpload<T: Decodable>(
        route: APIConfiguration,
        imageData: Data,
        key: String? = nil,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) -> DataRequest {
        session.upload(
            multipartFormData: { multipartFormData in
                // Add any additional parameters
                if let data = "image/jpeg".data(using: .utf8) {
                    multipartFormData.append(data, withName: "Content-Type")
                }
                
                if let parameters = route.parameters {
                    for (key, value) in parameters where key != "file" && key != "url" {
                        guard let data = "\(value)".data(using: .utf8) else { continue }
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                // Add image data if available
                if let key {
                    multipartFormData.append(imageData, withName: "file", fileName: key, mimeType: "image/jpeg")
                }
                
            },
            to: route.urlRequest?.url ?? "",
            method: route.method
        ).responseDecodable(of: T.self) { response in
            self.handleResponse(route: route, response: response, completion: completion)
        }
    }
    
    // MARK: Private Methods
    
    private func handleResponse<T: Decodable>(
        route: APIConfiguration,
        response: AFDataResponse<T>,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        logResponse(route: route, response: response)
        
        if handleErrorHeader(response: response) { return }
        if let responseError = response.error {
            handleResponseError(
                response: response,
                route: route,
                responseError: responseError,
                completion: completion
            )
            return
        }
        
        if response.data != nil {
            if let statusCode = response.response?.statusCode {
                handleStatusCode(
                    statusCode: statusCode,
                    route: route,
                    response: response,
                    completion: completion
                )
            } else {
                completion(.failure(CustomNetworkError.generic_error))
            }
        } else {
            completion(.failure(CustomNetworkError.empty_data))
        }
        
    }
    
    private func handleErrorHeader<T>(response: AFDataResponse<T>) -> Bool {
        if let errorHeader = response.response?.allHeaderFields["x-error"] as? String,
           errorHeader == ErrorCodeType.riderInNewDevice.rawValue {
            Constants.IS_RIDER_IN_NEW_DEVICE = true
            logout()
            return true
        }
        return false
    }

    private func handleResponseError<T: Decodable>(
        response: AFDataResponse<T>,
        route: APIConfiguration,
        responseError: AFError,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        
        // Check if the error is a timeout error
        if case let .sessionTaskFailed(error) = responseError,
           let urlError = error as? URLError,
           urlError.code == .timedOut {
            DispatchQueue.main.async {
//                if let topViewController = UIViewController.getTopViewController() {
//                    topViewController.showToast(message: Constants.timeoutError)
//                }
            }
            completion(.failure(CustomNetworkError.timeout))
            return
        }

        // Check if the error is a response serialization error
        if case let .responseSerializationFailed(reason) = responseError {
            switch reason {
            case .invalidEmptyResponse:
                // Handle the empty response case
                completion(.failure(CustomNetworkError.empty_data))
                return
            default:
                break
            }
        }
        
        let localizedDescription = responseError.localizedDescription
        if response.data != nil {
            if let statusCode = response.response?.statusCode {
                handleStatusCode(
                    statusCode: statusCode,
                    route: route,
                    response: response,
                    completion: completion
                )
            } else {
                completion(.failure(CustomNetworkError.generic_error))
            }
            return
        } else {
            logger.error("Error: \(localizedDescription)")
            completion(.failure(CustomNetworkError.readError(responseError)))
        }
    }

    private func logResponse<T>(route: APIConfiguration, response: AFDataResponse<T>) {
        let text = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "unknown"
        let stringURL = route.urlRequest?.url?.absoluteString ?? "unknown"
        let statusCode = response.response?.statusCode.description ?? "unknown"
        logger.info("Response: \(stringURL), Status code: \(statusCode), Data: \(text)")
    }

    private func handleStatusCode<T: Decodable>(
        statusCode: Int,
        route: APIConfiguration,
        response: AFDataResponse<T>,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        switch statusCode {
        case NetworkStatusCode.success.rawValue, NetworkStatusCode.success201.rawValue:
            handleSuccessStatusCode(response: response, completion: completion)
        case NetworkStatusCode.noContent.rawValue:
            handleNoContentStatusCode(responseData: response.data, completion: completion)
        case NetworkStatusCode.unauthorized.rawValue:
            handleUnauthorizedStatusCode(route: route, completion: completion)
        case NetworkStatusCode.badRequest.rawValue, NetworkStatusCode.notFound.rawValue, NetworkStatusCode.forbidden.rawValue:
            handleClientErrorStatusCode(responseData: response.data, completion: completion)
        default:
            handleDefaultErrorStatusCode(responseData: response.data, completion: completion)
        }
    }

    private func handleSuccessStatusCode<T>(
        response: AFDataResponse<T>,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        switch response.result {
        case .success(let success):
            completion(.success(success))
        case .failure(let error):
            completion(.failure(CustomNetworkError.readError(error)))
        }
    }

    private func handleNoContentStatusCode<T>(
        responseData: Data?,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        let error = ErrorHandler().errorMessage(data: responseData)
        completion(.failure(CustomNetworkError.errorData(error)))
    }

    private func handleClientErrorStatusCode<T>(
        responseData: Data?,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        let error = ErrorHandler().errorMessage(data: responseData)
        completion(.failure(CustomNetworkError.errorData(error)))
    }

    private func handleDefaultErrorStatusCode<T>(
        responseData: Data?,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        let error = ErrorHandler().errorMessage(data: responseData)
        completion(.failure(CustomNetworkError.errorData(error)))
    }

}
