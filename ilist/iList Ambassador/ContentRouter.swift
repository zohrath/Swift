//
//  UserRouter.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 26/03/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation
import Alamofire

public enum ContentEndpoint {
    case getContentForAmbassadorship(id: Int, page: Int, pageSize: Int)
    case getContent(contentId: Int)
    case consumeAmbassadorshipContent(contentId: Int)
    case shareAmbassadorshipContent(contentId: Int, targetUserId: Int)
    case getContentInbox()
    case getSharedContent(contentId: Int)
    case createOutboundLink(contentId: Int)
}

open class ContentRouter: BaseRouter {
    
    var endpoint: ContentEndpoint
    
    public init(endpoint: ContentEndpoint) {
        self.endpoint = endpoint
    }
    
    override open var method: HTTPMethod {
        switch endpoint {
        case .getContentForAmbassadorship: return .get
        case .getContent: return .get
        case .consumeAmbassadorshipContent: return .patch
        case .shareAmbassadorshipContent: return .post
        case .getContentInbox: return .get
        case .getSharedContent: return .get
        case .createOutboundLink: return .post
        }
    }
    
    override open var path: String {
        switch endpoint {
        case .getContentForAmbassadorship(let id, _, _): return "content-spectator/\(id)/"
        case .getContent(let id): return "ambassadorship-contents/\( id )"
        case .consumeAmbassadorshipContent(let contentId): return "use-content/\(contentId)/"
        case .shareAmbassadorshipContent(_, _): return "share-content/"
        case .getContentInbox(): return "users-inbox/"
        case .getSharedContent(let id): return "share-content/\(id)/"
        case .createOutboundLink(_): return "share-content-via-link/"
        }
    }
    
    override open var parameters: Parameters? {
        switch endpoint {
        case .shareAmbassadorshipContent(let contentId, let targetUserId):
            return ["content_id": contentId,"share_to" : targetUserId]
        case .createOutboundLink(let contentId):
            return ["content_id": contentId]
        default: return nil
        }
    }
    
    override open var encoding: ParameterEncoding? {
        switch endpoint {
        case .consumeAmbassadorshipContent(_): return JSONEncoding.default
        case .shareAmbassadorshipContent(_): return JSONEncoding.default
        case .createOutboundLink(_): return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
}
