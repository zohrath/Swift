//
//  BaseManager2.swift
//  iList Ambassador
//
//  Created by External Three. Consultant on 16/11/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation
import Alamofire

typealias DictionaryResponseBlock = (_ response: [String:Any]?, _ error: Error?) -> ()

open class BaseManager {
    
    lazy var sessionManager: SessionManager = {
        let sessionManager = SessionManager()
        sessionManager.adapter = OAuth2Handler.sharedInstance
        sessionManager.retrier = OAuth2Handler.sharedInstance
        return sessionManager
    }()
    
    static var credentials: iListOAuthClientCredentials{
        return iListOAuthClientCredentials()
    }
    
    static var baseUrlString: String {
        if let dict = Bundle.main.object(forInfoDictionaryKey: "iListAPI") as? [String:Any], let baseUrl = dict["API_URL"] as? String {
            return baseUrl
        }
        fatalError("[\(Mirror(reflecting: self).description) - \( #function ))] API url not found in .plist")
    }
    
    var hasAccessToken: Bool {
        return OAuth2Handler.hasAccessToken
    }
    
    // MARK: - Authentication
    
    func performRequest(withRouter router: BaseRouter, _ completionHandler: @escaping ((DataResponse<Any>) -> Void)) {
        do {
            let request = try router.asURLRequest()
            sessionManager.request(request).validate().responseJSON { (response: DataResponse<Any>) in
#if DEBUG
                switch response.result {
                case .success(let dict):
                    print("SUCCESS: \(request.url?.absoluteString): \(JSON.prettyJsonString(value: dict))")
                case .failure(let error):
                    if let url = request.url?.absoluteString {
                        print("ERROR \(url): \( error.localizedDescription )")
                    }
                }
#endif
                completionHandler(response)
            }
        } catch {
            debugPrint("error: \( error.localizedDescription )")
            fatalError("Unable to get url request from router")
        }
    }
    
}
