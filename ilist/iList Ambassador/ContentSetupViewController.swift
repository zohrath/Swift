//
//  ContentPageViewController.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-07-20.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import Crashlytics
import Alamofire

class ContentSetupViewController: UIViewController {
    
    // MARK: Data
    var ambassadorship: Ambassadorship? {
        didSet {
            if let ambassadorship = ambassadorship {
                updateContentWithId(ambassadorship.id)
            }
        }
    }
    var contentId: Int? {
        didSet {
            if let contentId = contentId {
                updateContentWithContentId(contentId)
            }
        }
    }
    var contents: [Content]? {
        didSet {
            if let contents = contents {
                self.showEmptyState(contents.isEmpty)
            } else {
                self.showEmptyState(true)
            }
        }
    }
    var content: Content?
    
    lazy var outboundShareManager: OutboundShareManager = {
        return OutboundShareManager(presentingViewController: self)
    }()
    
    // MARK: - Views
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var brandButton: BrandButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    // MARK: - Varibles
    var currentContent = 0
    var currentPage = 0
    var contentShareId = 0
    
    // MARK: - Statistics
    var statistics: AmbassadorStatistic?
    var statsTimer = Timer()
    var startTime = TimeInterval()
    var secondsOnPage: Int = 0
    var clicksOnPage: Int = 0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeBrand),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        
        emptyStateLabel.text = NSLocalizedString("NO_CONTENT_AVAILABLE", comment: "")
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Empty state
    
    fileprivate func showEmptyState(_ show: Bool) {
        emptyStateLabel.isHidden = !show
    }

    // MARK: Actions
    
    @IBAction func exitBrand(_ sender: BrandButton) {
        closeBrand()
    }
    
    func closeBrand() {
        let cells = contentCollectionView.visibleCells
        for cell in cells {
            if let cell = cell as? SinglePage {
                cell.pauseMedia()
            } else if let cell = cell as? MultiPage {
                cell.reset()
            }
        }
        NotificationCenter.default.removeObserver(NSNotification.Name.UIApplicationDidEnterBackground)
        endStats()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        scrollContent(-1)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        scrollContent(1)
    }
    
    func scrollContent(_ direction: Int) {
        contentCollectionView.scrollHorizontal(currentContent + direction, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShareSegue" {
            let navVC = segue.destination as! UINavigationController
            if let vc = navVC.viewControllers.first as? ShareContentViewController {
                vc.contentShareId = self.contentShareId
            }
        } else if segue.identifier == "showShareOutboundSegue" {
            let navVC = segue.destination as! UINavigationController
            if let vc = navVC.viewControllers.first as? ShareContentViewController {
                vc.contentShareId = self.contentShareId
                vc.performOutboutShareOnAppear = true
            }
        }
    }
    func setBrandImg(_ imgString: String) {
        Alamofire.request(imgString).responseImage { response in
                if let image = response.result.value {
                    self.brandButton.setImage(image, for: .normal)
                }
        }
    }

    // MARK: - Content
    
    func updateContentWithId(_ id: Int) {
        ContentManager.sharedInstance.getContentForId(id) { (contents, error) in
            if let contents = contents {
                self.contents = contents
                DispatchQueue.main.async(execute: {
                    self.setupStatistics(contents)
                    self.handleContentButtons()
                    self.contentCollectionView.reloadData()
                })
            } else if let error = error {
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }
    
    func updateContentWithContentId(_ id: Int) {
        ContentManager.sharedInstance.getSharedContent(id, completion: {contents, error in
            if let contents = contents {
                self.contents = contents
                DispatchQueue.main.async(execute: {
                    self.setupStatistics(contents)
                    self.handleContentButtons()
                    self.contentCollectionView.reloadData()
                })
            } else if let error = error {
                Crashlytics.sharedInstance().recordError(error)
            }
        })
    }
    
    // MARK: - Statistics
    
    func setupStatistics(_ contents: [Content]) {
        backgroundThread(0.0, background: {
            var contentIds = [Int]()
            var pageIds = [Int:[Int]]()
            var i = 0
            for content in contents {
                contentIds.append(content.id)
                var ids = [Int]()
                for page in content.pages {
                    ids.append(page.id)
                }
                pageIds[i] = ids
                i += 1
            }
            var statId = 0
            if let id = self.contentId {
                statId = id
            } else if let ambassadorship = self.ambassadorship {
                statId = ambassadorship.id
            }
            self.statistics = AmbassadorStatistic(id: statId, contentIds: contentIds, pageIds: pageIds)
            }, completion: {
                self.resetTimer()
                self.startTimer()
        })
    }
    
    func resetTimer() {
        statsTimer.invalidate()
    }
    
    func startTimer() {
        if !statsTimer.isValid {
            statsTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime
        let minutes = round(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = round(elapsedTime)
        
        secondsOnPage = Int(seconds)
    }
    
    func endStats() {
        if let statis = statistics {
            statis.addPageDuration(currentContent, page: currentPage, seconds: secondsOnPage)
            StatisticsManager.sharedInstance.sendAmbassadorStatistics(statis, completion: { success, error in
                debugPrint("Error: \(error)")
            })
        }
    }
    
    func addClickCount() {
        if let stats = statistics {
            stats.addPageClicks(currentContent, page: currentPage, clicks: 1)
        }
    }
    
    func addDuration() {
        resetTimer()
        if let stats = statistics {
            stats.addPageDuration(currentContent, page: currentPage, seconds: secondsOnPage)
        }
        startTimer()
    }
}

extension ContentSetupViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let contents = contents {
            return contents.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiPageCell", for: indexPath) as! MultiPage
        if let contents = contents {
            let content = contents[indexPath.row]
            cell.content = content
            cell.delegatePaser = self
            cell.delegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? MultiPage {
            cell.reset()
        }
    }
    
}

extension ContentSetupViewController: MultiPageDelegate {
    
    func currentPage(_ page: Int) {
        addDuration()
        currentPage = page
    }
    
    func shareContent(_ id: Int) {
        showShare(id)
    }
    
    func shareContentOutbound(_ id: Int) {
        showShareOutbound(id)
    }
}

extension ContentSetupViewController : UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollOffset = scrollView.contentOffset.x
        let contentWidht = contentCollectionView.contentSize.width - contentCollectionView.frame.size.width
        var indexPath:IndexPath?
        if scrollOffset < 0 {
            indexPath = IndexPath(row: 0, section: 0)
        } else if scrollOffset > contentWidht {
            indexPath = IndexPath(row: contentCollectionView.numberOfHorizontalPages()-1, section: 0)
            scrollOffset = scrollOffset - contentWidht
        }
        if let indexPath = indexPath {
            if let cell = contentCollectionView.cellForItem(at: indexPath) as? MultiPage {
                cell.zoomBackground(scrollOffset, y: 0)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        calculateCurrentContentNumber()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        calculateCurrentContentNumber()
    }
    func calculateCurrentContentNumber() {
        addDuration()
        handleContentButtons()
    }
    func handleContentButtons() {
        currentContent = contentCollectionView.currentHorizontalPage()
        if let contents = contents, !contents.isEmpty {
            leftButton.isHidden = currentContent == 0
            rightButton.isHidden = contents.count - 1 == currentContent
        } else {
            leftButton.isHidden = true
            rightButton.isHidden = true
        }
    }
}

extension ContentSetupViewController: SinglePageDelegate {
    func showLink(_ link: String, contentId: Int) {
        addClickCount()
        let webViewController = WebViewController(link: link, contentId: contentId)
        present(webViewController, animated: true, completion: nil)
    }
    
    func showCode(_ code: String, asQR: Bool) {
        addClickCount()
        let contentConsumeInfoViewController = ContentConsumeInfoViewController(code: code, showAsQR: asQR)
        present(contentConsumeInfoViewController, animated: true, completion: nil)
    }
    
    func showContentConsumedWithAmbassadorshipContent(_ contentTitle: String) {
        addClickCount()
        let message = String(format: NSLocalizedString("CONTENT_HAS_BEEN_USED", comment: ""), contentTitle)
        let contentConsumeInfoViewController = ContentConsumeInfoViewController(message: message)
        present(contentConsumeInfoViewController, animated: true, completion: nil)
    }
    
    func showShare(_ contentId: Int) {
        addClickCount()
        contentShareId = contentId
        performSegue(withIdentifier: "showShareSegue", sender: nil)
    }
    
    func showShareOutbound(_ contentId: Int) {
        addClickCount()
        contentShareId = contentId
        outboundShareManager.shareOutbound(withContentId: contentShareId)
    }
    
    func showErrorMessage(_ message: String) {
        let contentConsumeInfoViewController = ContentConsumeInfoViewController(message: message)
        present(contentConsumeInfoViewController, animated: true, completion: nil)
    }
}

class ContentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {        
        itemSize = CGSize(width: SCREENSIZE.width, height: SCREENSIZE.height)
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        sectionInset = UIEdgeInsets.zero
    }
}

protocol ContentView {
    var view: UIView {get}
    var horizontalMarginPercent: CGFloat {get set}
    var bottomMarginPercent: CGFloat {get set}
    var marginEdgePercentage: CGFloat {get set}
    var height: CGFloat {get}
    var width: CGFloat {get}
    
    func prepareForReuse()
}
