//
//  MultiPage.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-07-20.
//  Copyright © 2016 iList AB. All rights reserved.
//


protocol MultiPageDelegate {
    func currentSubPage(_ page: Int)
    func currentPage(_ page: Int)
    func shareContent(_ id: Int)
    func shareContentOutbound(_ id: Int)
    func presentUseAlert(_ title: String, _ message: String)
    func shareFacebook(_ imageView: UIImageView)
    func shareInstagram(_ imageView: UIImageView)
    func shareTwitter(_ imageView: UIImageView)
}

protocol backgroundDelegate: class {
    func setShareImage(_ imageView: UIImageView)
}

let showShareButtonNotificationKey = "se.ilist.iList.showShareButton"

import UIKit
import Alamofire

class MultiPage: UICollectionViewCell, backgroundDelegate {
    
    

    
    
    
    @IBOutlet weak var downButton: BounchingButton!
    @IBOutlet weak var shareButton: BrandButton!
    @IBOutlet weak var outboundShareButton: BrandButton!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var instagramShareButton: UIButton!
    @IBOutlet weak var twitterShareButton: UIButton!
    
    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var multiPageCollectionView: UICollectionView!
    
    var current: Int?
    var currentContentPage: Int?
    let shareKey = Notification.Name(rawValue: showShareButtonNotificationKey)
    var x = 0
    var BG: UIImageView?
    var delegate: MultiPageDelegate?
    var delegatePaser: SinglePageDelegate?
    var currentPage: Int = 0 {
        didSet {
            delegate?.currentPage(currentPage)
        }
    }
    var currentSubPage: Int = 0 {
        didSet {
            delegate?.currentSubPage(currentSubPage)
        }
    }
    
    var content:Content? {
        didSet {
            if content != nil {
                useButton.imageView?.contentMode = .scaleAspectFit
                shareButton.imageView?.contentMode = .scaleAspectFit
                facebookShareButton.imageView?.contentMode = .scaleAspectFit
                instagramShareButton.imageView?.contentMode = .scaleAspectFit
                twitterShareButton.imageView?.contentMode = .scaleAspectFit
                
                let is_shareable = content?.pages[multiPageCollectionView.currentVerticalPage()].is_shareable!
                let shareable = content?.shareable
                
                if shareable! && is_shareable! {
                    facebookShareButton.isHidden = false
                    instagramShareButton.isHidden = false
                    twitterShareButton.isHidden = false
                    useButton.isHidden = true
                    shareButton.isHidden = true
                } else if shareable! && !is_shareable! {
                    facebookShareButton.isHidden = true
                    instagramShareButton.isHidden = true
                    twitterShareButton.isHidden = true
                    useButton.isHidden = false
                    shareButton.isHidden = false
                } else if !shareable! && is_shareable! {
                    facebookShareButton.isHidden = false
                    instagramShareButton.isHidden = false
                    twitterShareButton.isHidden = false
                    useButton.isHidden = true
                    shareButton.isHidden = true
                } else if !shareable! && !is_shareable! {
                    facebookShareButton.isHidden = true
                    instagramShareButton.isHidden = true
                    twitterShareButton.isHidden = true
                    useButton.isHidden = true
                    shareButton.isHidden = true
                }
                
                handlePageButtons(0)
                
                if multiPageCollectionView.dataSource == nil {
                    multiPageCollectionView.delegate = self
                    multiPageCollectionView.dataSource = self
                    
                }
                
                multiPageCollectionView.reloadData()
            }
            print("Initial current subpage says: \(multiPageCollectionView.currentVerticalPage())")
        }
    }
    
    func presentUseAlert(_ title: String, _ message: String) {
        
    }
    
    
    func shareButtons(_ contentNumber: Int?, _ subPageNumber: Int?) {}
    
    
        func reset() {
        if let content = content, content.pages.count > 0 {
            multiPageCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        pauseCells()
    }
    
    func pauseCells() {
        let cells = multiPageCollectionView.visibleCells as! [SinglePage]
        for cell in cells {
            cell.pauseMedia()
        }
    }
    
    func shareButtons(subPageNumber: Int) {
        
        let is_shareable = content?.pages[multiPageCollectionView.currentVerticalPage()].is_shareable!
        let shareable = content?.shareable
        
        if shareable! && is_shareable! {
            facebookShareButton.isHidden = false
            instagramShareButton.isHidden = false
            twitterShareButton.isHidden = false
            useButton.isHidden = true
            shareButton.isHidden = true
        } else if shareable! && !is_shareable! {
            facebookShareButton.isHidden = true
            instagramShareButton.isHidden = true
            twitterShareButton.isHidden = true
            useButton.isHidden = false
            shareButton.isHidden = false
        } else if !shareable! && is_shareable! {
            facebookShareButton.isHidden = false
            instagramShareButton.isHidden = false
            twitterShareButton.isHidden = false
            useButton.isHidden = true
            shareButton.isHidden = true
        } else if !shareable! && !is_shareable! {
            facebookShareButton.isHidden = true
            instagramShareButton.isHidden = true
            twitterShareButton.isHidden = true
            useButton.isHidden = true
            shareButton.isHidden = true
        }

    }
    
     /*
    func retrieveImage(_ url: String) {
        Alamofire.request(url).downloadProgress(closure: { (Progress) in
            print(Progress.fractionCompleted)
        }).responseData { (response) in
            print(response.result)
            print(response.result.value)
            
            if let image = response.result.value {
                self.testImageView.image = UIImage(data: image)
                
            }
        }
    }
 */
    
    // MARK: BackgroundDelegate
    
    func setShareImage(_ imageView: UIImageView) {
        shareImageView = imageView
    }
    
    

    
    // MARK: - Actions
 
    @IBAction func facebookShareButtonPressed(_ sender: UIButton) {
        guard let image = shareImageView else { return }
            delegate?.shareFacebook(image)
    }
    
    @IBAction func instagramShareButtonPressed(_ sender: UIButton) {
        guard let image = shareImageView else { return }
        delegate?.shareInstagram(image)
    }
    
    @IBAction func twitterShareButton(_ sender: Any) {
        guard let image = shareImageView else { return }
        delegate?.shareTwitter(image)
    }
    
    
    
    
    @IBAction func useButtonPressed(_ sender: UIButton) {
        
        var title = ""
        var message = "POTENTIAL SUBMESSAGE HERE"
        
        guard content != nil else { return }
        let consumeType = content?.consumeAction
        
        if consumeType == .information {
            title = "Information"
        } else if consumeType == .onlyConsumable {
            title = "Use"
        } else if consumeType == .link {
            title = "Follow link"
        } else if consumeType == .code {
            title = "Use the code below"
            message = "CODE IS PRESENTED HERE"
        } else if consumeType == .affiliate {
            title = "Would you like to become an affiliate"
        } else if consumeType == .document {
            title = "Open PDF Document"
        }
        
        
        
        delegate?.presentUseAlert(title, message)
       
        print("Use button pressed, activate functionality based on pages[].consume_action. document, affiliate, link works")
    }
    
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        scrollPage(-1)
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        scrollPage(1)
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        if let content = content {
            delegate?.shareContent(content.id)
        }
    }
    
    @IBAction func outboundShareButtonPressed(_ sender: Any) {
        if let content = content {
            delegate?.shareContentOutbound(content.id)
            
        }
    }
    // Problem?
    func scrollPage(_ direction: Int) {
        currentSubPage += direction
        multiPageCollectionView.scrollVertical(currentPage + direction, animated: true)
    }
    
    // MARK: - Animations
    
    func zoomBackground(_ x: CGFloat, y: CGFloat) {
        let indexPath = IndexPath(row: currentPage, section: 0)
        if let cell = multiPageCollectionView.cellForItem(at: indexPath) as? SinglePage {
            cell.zoomBackground(x, y: y)
        }
    }
    
    
}

extension MultiPage: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let content = content {
            return content.pages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! SinglePage
        if let content = content {
            cell.delegate = delegatePaser
            cell.BGDelegate = self
            let claimableCell = content.claimable && collectionView.isLastIndexPathInCollectionView(indexPath)
            let consumeAction = claimableCell ? content.consumeAction : nil
            let isShareable = content.shareable && collectionView.isLastIndexPathInCollectionView(indexPath)
            
            cell.configure(with: content,
                           consumeAction: consumeAction,
                           shareable: isShareable,
                           pageIndex: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! SinglePage
        cell.pauseMedia()
    }
    
    func handlePageButtons(_ page: Int) {
        if currentPage != page {
            let cell = multiPageCollectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: IndexPath(row: currentPage, section: 0)) as! SinglePage
            cell.pauseMedia()
        }
        currentPage = page
        if let content = content {
            upButton.isHidden = page == 0
            downButton.isHidden = content.pages.count - 1 == page
        }
    }
    

}


extension MultiPage : UIScrollViewDelegate, UICollectionViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        var scrollOffset = scrollView.contentOffset.y
        let contentHeight = multiPageCollectionView.contentSize.height - multiPageCollectionView.frame.size.height
        var indexPath:IndexPath?
        if scrollOffset < 0 {
            indexPath = IndexPath(row: 0, section: 0)
        } else if scrollOffset > contentHeight {
            indexPath = IndexPath(row: multiPageCollectionView.numberOfVerticalPages()-1, section: 0)
            scrollOffset = scrollOffset - contentHeight
        }
        if let indexPath = indexPath {
            if let cell = multiPageCollectionView.cellForItem(at: indexPath) as? MultiPage {
                cell.zoomBackground(0, y: scrollOffset)
            } else if let cell = multiPageCollectionView.cellForItem(at: indexPath) as? SinglePage {
                cell.zoomBackground(0, y: scrollOffset)
            }
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        calculateCurrentPageNumber()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        calculateCurrentPageNumber()
    }
    func calculateCurrentPageNumber() {
        let page = multiPageCollectionView.currentVerticalPage()
        currentSubPage += multiPageCollectionView.currentVerticalPage()
        
        //getFileUrl((content?.pages[multiPageCollectionView.currentVerticalPage()].backgrounds)!)
        shareButtons(subPageNumber: multiPageCollectionView.currentVerticalPage())
        
        handlePageButtons(page)

    }
}
