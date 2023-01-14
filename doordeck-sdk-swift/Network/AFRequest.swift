//
//  AFRequest.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Alamofire
#if os(iOS)
import Cache
#endif
import Foundation

/**
 * Simple wrapper around Alamofire
 */
class AFRequest {
    #if os(iOS)
    let connectivityManager: ReachabilityHelper
    #endif
    var sessionManager = Alamofire.Session.default //Alamofire.SessionManager.default
    
    init() {
        #if os(iOS)
        self.connectivityManager = ReachabilityHelper()
        #endif
        append(additional:[:])
    }
    
    func append(additional headers: [String: String]) {
        var defaultHeaders = HTTPHeaders.default
        
        for (key, value) in headers {
            defaultHeaders[key] = value
        }
        
        let memoryCapacity = 100 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        
        #if os(iOS)
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nil)
        #endif
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders.dictionary
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        #if os(iOS)
        configuration.urlCache = cache
        #endif
        
        let redirector = Redirector(behavior: .modify { task, request, response in
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
        })
        
        sessionManager = Alamofire.Session(configuration: configuration, serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicy()), redirectHandler: redirector)
    }
    
    func handleJsonResponse(_ url: String,
                            response: HTTPURLResponse?,
                            result: Swift.Result<Any, AFError>,
                            onSuccess: @escaping (_ jsonData: AnyObject) -> Void,
                            onError: ((_ error: APIClient.error) -> Void)?) {
        
        
        if let statusCode = response?.statusCode {
            switch(statusCode) {
            
            case 200, 201, 202, 203, 204:
                
                switch result {
                case let .success(value):
                    onSuccess(value as AnyObject)
                case let .failure(error):
                    let error = error as NSError
                    
                    print(PrintChannel.error, object: "AFRequest Error \(error) \n URL: \(url)")
                    onError?(APIClient.error.network(networkError: error))
                }
            case 401:
                SDKEvent().event(.NETWORK_ERROR)
                print(PrintChannel.error,
                      object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode))
                
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
                        result: Swift.Result<String, AFError>,
                        onSuccess: @escaping (_ jsonData: AnyObject) -> Void,
                        onError: ((_ error: APIClient.error) -> Void)?) {
        
        
        if let statusCode = response?.statusCode {
            switch(statusCode) {
            
            case 200, 201, 202, 203, 204:
                
                switch result {
                case let .success(value):
                    onSuccess(value as AnyObject)
                case let .failure(error):
                    let error = error as NSError
                    
                    print(PrintChannel.error,
                          object: "AFRequest Error \(error) \n URL: \(url)")
                    onError?(APIClient.error.network(networkError: error))
                }
            case 401:
                SDKEvent().event(.NETWORK_ERROR)
                print(PrintChannel.error, object: "AFRequest Error \(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode)) \n URL: \(url)")
                onError?(APIClient.error.unsuccessfulHTTPStatusCode(statusCode: statusCode))
                
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
    
    func serverTrustPolicy() -> [String: PinnedCertificatesTrustEvaluator]{
        let bundle: Bundle = Bundle(for: type(of: self))
        let amazonRootCA1Data = NSData(contentsOf: bundle.url(forResource: "AmazonRootCA1", withExtension: "cer")!)
        let amazonRootCA2Data = NSData(contentsOf: bundle.url(forResource: "AmazonRootCA2", withExtension: "cer")!)
        let amazonRootCA3Data = NSData(contentsOf: bundle.url(forResource: "AmazonRootCA3", withExtension: "cer")!)
        let amazonRootCA4Data = NSData(contentsOf: bundle.url(forResource: "AmazonRootCA4", withExtension: "cer")!)
        let amazonRootCA5Data = NSData(contentsOf: bundle.url(forResource: "SFSRootCAG2", withExtension: "cer")!)
        
        let amazonRootCA1 = PinnedCertificatesTrustEvaluator(certificates: [SecCertificateCreateWithData(nil, amazonRootCA1Data!)!,
                                                                            SecCertificateCreateWithData(nil, amazonRootCA2Data!)!,
                                                                            SecCertificateCreateWithData(nil, amazonRootCA3Data!)!,
                                                                            SecCertificateCreateWithData(nil, amazonRootCA3Data!)!,
                                                                            SecCertificateCreateWithData(nil, amazonRootCA4Data!)!,
                                                                            SecCertificateCreateWithData(nil, amazonRootCA5Data!)!], acceptSelfSignedCertificates: false, performDefaultValidation: true, validateHost: true)
        
        
        return ["api.doordeck.com" : amazonRootCA1,
                "api.staging.doordeck.com" : amazonRootCA1,
        ]
    }
    
    func cancelAllRequests() {
        sessionManager.session.getAllTasks{ tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    func isConnected() -> Bool {
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
        
        let headersTemp = HTTPHeaders.init(headers ?? [:])
        
        if isConnected() {
            if jsonReply == true {
                sessionManager.request(url,
                                       method: method,
                                       parameters: params,
                                       encoding: encoding,
                                       headers: headersTemp)
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
                                       headers: headersTemp)
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
