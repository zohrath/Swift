//
//  OAuth2Handler.swift
//  iList Ambassador
//
//  Created by External Three. Consultant on 16/11/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation
import Alamofire

class OAuth2Handler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    static let sharedInstance: OAuth2Handler = {
        return OAuth2Handler(baseURLString: BaseManager.baseUrlString)
    }()
    
    private let lock = NSLock()
    
    private var baseURLString: String
    private var accessToken: String?
    private var refreshToken: String?
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(baseURLString: String) {
        self.baseURLString = baseURLString
        self.accessToken = Keychain.loadAccessToken()
        self.refreshToken = Keychain.loadRefreshToken()
    }
    
    public func update(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        Keychain.storeAccessToken(accessToken, refreshToken: refreshToken)
    }
    
    public func clearAccessToken() {
        self.accessToken = nil
        self.refreshToken = nil
        Keychain.clearAccessToken()
    }
    
    // MARK: - Public methods
    
    static var hasAccessToken: Bool {
        return Keychain.hasAccessToken
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let url = urlRequest.url, url.absoluteString.hasPrefix(baseURLString), let accessToken = accessToken {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = accessToken, let refreshToken = refreshToken {
                        strongSelf.update(accessToken: accessToken, refreshToken: refreshToken)
                    } else if !succeeded {
                        strongSelf.clearAccessToken()
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing, let refreshToken = refreshToken else { return }
        
        isRefreshing = true
        
        let urlString = "\(baseURLString)o/token/"
        
        let parameters: [String: Any] = [
            "refresh_token": refreshToken,
            "grant_type": "refresh_token",
            "client_id" : iListOAuthClientCredentials.getClientId(),
            "client_secret" : iListOAuthClientCredentials.getClientSecret()
        ]
        
        sessionManager.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).validate()
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                if let json = response.result.value as? [String: Any], let accessToken = json["access_token"] as? String, let refreshToken = json["refresh_token"] as? String {
                    completion(true, accessToken, refreshToken)
                } else {
                    completion(false, nil, nil)
                }
                
                strongSelf.isRefreshing = false
        }
    }
}
