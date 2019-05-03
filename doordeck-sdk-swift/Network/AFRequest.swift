//
//  AFRequest.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Alamofire

/**
 * Simple wrapper around Alamofire
 */
class AFRequest {
    #if os(iOS)
    fileprivate let connectivityManager: ReachabilityHelper
    #endif
    var sessionManager = Alamofire.SessionManager.default
    
    init() {
        #if os(iOS)
            self.connectivityManager = ReachabilityHelper()
        #endif
        append(additional:[:])
    }
    
    func append(additional headers: [String: String]) {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        for (key, value) in headers {
            defaultHeaders[key] = value
        }
        
        let memoryCapacity = 100 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nil)
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = cache
        
        sessionManager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicy()))
        
        sessionManager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var redirectedRequest = request
            
            if
                let originalRequest = task.originalRequest,
                let headers = originalRequest.allHTTPHeaderFields,
                let authorizationHeaderValue = headers["Authorization"]
            {
                var mutableRequest = request
                mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
                redirectedRequest = mutableRequest
            }
            
            return redirectedRequest
        }
    }
    
    func handleJsonResponse(_ url: String,
                            response: HTTPURLResponse?,
                            result: Result<Any>,
                            onSuccess: @escaping (_ jsonData: AnyObject) -> Void,
                            onError: ((_ error: APIClient.error) -> Void)?) {
        
        
        if let statusCode = response?.statusCode {
            switch(statusCode) {
                
            case 200, 201, 202, 203, 204:
                if result.isSuccess {
                    onSuccess(result.value as AnyObject)
                } else if result.isFailure {
                    let error = result.error! as NSError
                    
                    print(PrintChannel.error, object: "AFRequest Error \(error) \n URL: \(url)")
                    onError?(APIClient.error.network(networkError: error))
                }
            case 401:
                SDKEvent().event(.NETWORK_ERROR)
                print(PrintChannel.error,
                      object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode))
                
                doordeckNotifications().logout()
                
            case 423:
                print(PrintChannel.error,
                      object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.twoFactorAuthenticationNeeded)
                
            default:
                SDKEvent().event(.NETWORK_ERROR)
                print(PrintChannel.error,
                      object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode))
            }
            
        } else {
            SDKEvent().event(.NETWORK_ERROR)
            print(PrintChannel.error, object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: 500)) \n URL: \(url)")
            onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: 500))
        }
    }
    
    func handleResponse(_ url: String,
                        response: HTTPURLResponse?,
                        result: Result<String>,
                        onSuccess: @escaping (_ jsonData: AnyObject) -> Void,
                        onError: ((_ error: APIClient.error) -> Void)?) {
        
        
        if let statusCode = response?.statusCode {
            switch(statusCode) {
                
            case 200, 201, 202, 203, 204:
                
                
                if result.isSuccess {
                    onSuccess(result.value as AnyObject)
                } else if result.isFailure {
                    let error = result.error! as NSError
                    
                    print(PrintChannel.error,
                          object: "AFRequest Error \(error) \n URL: \(url)")
                    onError?(APIClient.error.network(networkError: error))
                }
            case 401:
                SDKEvent().event(.NETWORK_ERROR)
                print(PrintChannel.error, object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode))
                
                doordeckNotifications().logout()
                
            case 423:
                print(PrintChannel.error,
                      object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.twoFactorAuthenticationNeeded)
                
            default:
                SDKEvent().event(.NETWORK_ERROR)
                print(PrintChannel.error,
                      object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode))
            }
            
        } else {
            SDKEvent().event(.NETWORK_ERROR)
            print(PrintChannel.error,
                  object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: 500)) \n URL: \(url)")
            onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: 500))
        }
    }
    
    func serverTrustPolicy() -> [String: ServerTrustPolicy]{
        let amazonRootCA1Data = NSData(contentsOf: Bundle.main.url(forResource: "AmazonRootCA1", withExtension: "cer")!)
        let amazonRootCA1 = ServerTrustPolicy.pinCertificates(certificates: [SecCertificateCreateWithData(nil, amazonRootCA1Data!)!], validateCertificateChain: true, validateHost: true)
        
        return ["api.doordeck.com" : amazonRootCA1,
                "api.staging.doordeck.com" : amazonRootCA1,
        ]
    }
    
    func cancelAllRequests() {
        sessionManager.session.getAllTasks{ tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    fileprivate func isConnected() -> Bool {
        #if os(iOS)
            return connectivityManager.isConnected
        #else
            return true
        #endif
    }
    
    func request(_ url: String,
                 method: HTTPMethod,
                 params: [String: AnyObject]?,
                 encoding: ParameterEncoding = JSONEncoding.default,
                 headers: [String: String]?,
                 jsonReply: Bool = true,
                 onSuccess: @escaping (_ jsonData: AnyObject) -> Void,
                 onError: ((_ error: APIClient.error) -> Void)?) {
        
        if isConnected() {
            if jsonReply == true {
                sessionManager.request(url,
                                       method: method,
                                       parameters: params,
                                       encoding: encoding,
                                       headers: headers)
                    .responseJSON(options: JSONSerialization.ReadingOptions())
                    { (response) in
                        self.handleJsonResponse(url,
                                                response: response.response,
                                                result: response.result,
                                                onSuccess: onSuccess,
                                                onError: onError)
                }
                
            } else {
                sessionManager.request(url,
                                       method: method,
                                       parameters: params,
                                       encoding: encoding,
                                       headers: headers)
                    .responseString(completionHandler:
                        { (response) in
                            self.handleResponse(url,
                                                response: response.response,
                                                result: response.result,
                                                onSuccess: onSuccess,
                                                onError: onError)
                    })
                
            }
        } else {
            SDKEvent().event(.NO_INTERNET)
            print(PrintChannel.error,
                  object: "NoInternet \(APIClient.error.noInternet) \n URL: \(url)")
            onError?(APIClient.error.noInternet)
        }
        
    }
    
}
