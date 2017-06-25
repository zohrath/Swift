//
//  AmbassadorStatistic.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-07-15.
//  Copyright © 2016 iList AB. All rights reserved.
//

import Foundation

class AmbassadorStatistic {

    let ambassadorId: Int
    var content: [ContentStatistic]
        
    class ContentStatistic {
        let contentId: Int
        var pages: [PageStatistic]
        
        class PageStatistic {
            let pageId: Int
            var durationPage: Int
            var clicks: Int
            
            init(pageId: Int) {
                self.pageId = pageId
                self.durationPage = 0
                self.clicks = 0
            }
            
            func addDuration(_ seconds: Int) {
                self.durationPage += seconds
            }
            
            func addClicks(_ clicks: Int) {
                self.clicks += clicks
            }
        }
        
        init(id: Int, pageIds: [Int]) {
            self.contentId = id
            self.pages = []
            for page in pageIds {
                self.pages.append(PageStatistic(pageId: page))
            }
        }
    }
    
    init(id: Int, contentIds: [Int], pageIds: [Int:[Int]]) {
        self.ambassadorId = id
        self.content = []
        for i in 0..<contentIds.count {
            self.content.append(ContentStatistic(id: contentIds[i], pageIds: pageIds[i]!))
        }
    }
    
    func addPageDuration(_ content:Int, page:Int, seconds:Int) {
        if content < self.content.count {
            let c = self.content[content]
            if page < c.pages.count {
                c.pages[page].addDuration(seconds)
            }
        }
    }
    
    func addPageClicks(_ content:Int, page:Int, clicks:Int) {
        if content < self.content.count {
            let c = self.content[content]
            if page < c.pages.count {
                c.pages[page].addClicks(clicks)
            }
        }
    }
    
    func getId() -> Int {
        return self.ambassadorId
    }
    
    func toDict() -> [[String: AnyObject]] {
        var contDict = [[String: AnyObject]]()
        for cont in content {
            var pages = [[String:Any]]()
            for page in cont.pages {
                pages.append(["page_id":page.pageId as AnyObject, "duration" : page.durationPage as AnyObject, "clicks" : page.clicks as AnyObject])
            }
            contDict.append(["content_id" : cont.contentId as AnyObject, "page_stats" : pages as AnyObject])
        }
        return contDict
    }
}
