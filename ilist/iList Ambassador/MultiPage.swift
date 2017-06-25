//
//  MultiPage.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-07-20.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
protocol MultiPageDelegate {
    func currentPage(_ page: Int)
    func shareContent(_ id: Int)
    func shareContentOutbound(_ id: Int)
}

class MultiPage: UICollectionViewCell {
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: BounchingButton!
    @IBOutlet weak var shareButton: BrandButton!
    @IBOutlet weak var outboundShareButton: BrandButton!
    
    var delegate: MultiPageDelegate?
    var delegatePaser: SinglePageDelegate?
    var currentPage: Int = 0 {
        didSet {
            delegate?.currentPage(currentPage)
        }
    }
    
    @IBOutlet weak var multiPageCollectionView: UICollectionView!
    
    var content:Content? {
        didSet {
            if let content = content {
                handlePageButtons(0)
                if multiPageCollectionView.dataSource == nil {
                    multiPageCollectionView.delegate = self
                    multiPageCollectionView.dataSource = self
                }
                if content.shareable {
                    shareButton.isHidden = false
                    outboundShareButton.isHidden = false
                } else {
                    shareButton.isHidden = true
                    outboundShareButton.isHidden = true
                }
                multiPageCollectionView.reloadData()
            }
        }
    }
    
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
    
    // MARK: - Actions
    
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
    
    func scrollPage(_ direction: Int) {
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
        handlePageButtons(page)

    }
}
