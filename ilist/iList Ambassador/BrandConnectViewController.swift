//
//  BrandConnectViewController.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 24/04/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import AVFoundation

protocol BrandConnectDelegate {
    func successfullySignForNewAmbassadorship(_ ambassador:Ambassadorship)
}

class BrandConnectViewController: BaseViewController {
    
    var delegate: BrandConnectDelegate?
    
    // MARK: Views
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var scannerContainerView: UIView!
    
    @IBOutlet weak var titleLabel: NormalLabel!
    @IBOutlet weak var separatorLabel: NormalLabel!
    @IBOutlet weak var codeTextField: TextField!
    
    var codeReader: QRCodeReader?

    // MARK: Constraints
    @IBOutlet weak var containerViewVerticalCenterConstraint: NSLayoutConstraint!
    
    // MARK: - View life cycle
    
    convenience init() {
        self.init(nibName: "BrandConnectViewController", bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        codeReader?.stopScanning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if(authStatus == .authorized || authStatus == .notDetermined) {
            codeReader = QRCodeReader()
        } else if(authStatus == .denied) {
            // denied: show alert or something
        }
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = CornerRadius.Large
        
        scannerContainerView.layer.masksToBounds = true
        scannerContainerView.layer.cornerRadius = CornerRadius.Large
        scannerContainerView.backgroundColor = Color.backgroundColorGray()
        
        titleLabel.text = NSLocalizedString("SCAN_QR_CODE", comment: "")
        titleLabel.font = Font.boldFont(FontSize.Large)
        titleLabel.textColor = Color.blackColor()
        
        separatorLabel.text = NSLocalizedString("OR_ENTER_CODE", comment: "").lowercased()
        separatorLabel.font = Font.boldFont(FontSize.Small)
        separatorLabel.textColor = Color.darkGrayColor()
        
        codeTextField.placeholderColor = UIColor.lightGray
        codeTextField.placeholder = NSLocalizedString("CONNECTION_CODE", comment: "")
        codeTextField.clearButtonMode = .never
        codeTextField.delegate = self
        codeTextField.returnKeyType = UIReturnKeyType.send
        codeTextField.autocorrectionType = .no
        codeTextField.autocapitalizationType = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(BrandConnectViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BrandConnectViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let codeReader = codeReader {
            codeReader.previewLayer.frame = scannerContainerView.bounds
            if codeReader.previewLayer.connection.isVideoOrientationSupported {
                let orientation = UIDevice.current.orientation
                let videoOrientation = QRCodeReader.videoOrientationFromDeviceOrientation(orientation, withSupportedOrientations: supportedInterfaceOrientations)
                codeReader.previewLayer.connection.videoOrientation = videoOrientation
            }
            codeReader.previewLayer.frame = scannerContainerView.bounds
            scannerContainerView.layer.addSublayer(codeReader.previewLayer)
            view.setNeedsLayout() // Need to call setNeedsLayout() to invoke viewDidLayoutSubviews() to update scanner frame
            
            codeReader.didFindCodeBlock = didFindCodeBlock
            codeReader.startScanning()
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        codeReader?.previewLayer.frame = scannerContainerView.bounds
    }
    
    // MARK: - Actions
    
    @IBAction func backgroundViewTapped(_ sender: AnyObject) {
        codeTextField.resignFirstResponder()
    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject?) {
        codeReader?.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Catching Button Events
    
    func didFindCodeBlock(_ result: QRCodeReaderResult) -> Void {
        reader(self, didScanResult: result)
    }
    
    func reader(_ reader: BrandConnectViewController, didScanResult result: QRCodeReaderResult) {
        signNewAmbassadorShip(result.value)
    }
    
    func signNewAmbassadorShip(_ text: String) {
        AmbassadorshipManager.sharedInstance.requestAmbassadorhipWithCode(text, completion: {(ambassadorship, error) in
            if let Ambassadorship = ambassadorship {
                self.delegate?.successfullySignForNewAmbassadorship(Ambassadorship)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.codeReader?.startScanning()
            }
        })
    }
    
}

extension BrandConnectViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            AmbassadorshipManager.sharedInstance.requestAmbassadorhipWithCode(text, completion: {(ambassadorship, error) in
                if let ambassadorship = ambassadorship {
                    self.delegate?.successfullySignForNewAmbassadorship(ambassadorship)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlertWithTitle(NSLocalizedString("CONNECTION_CODE_DOES_NOT_EXISTS", comment: ""), message: nil, completion: {
                        textField.becomeFirstResponder()
                    })
                }
            })
        }
        return true
    }

    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let frameHeight = view.frame.size.height - keyboardHeight
        var height:CGFloat = 0
        let textFieldInView = codeTextField.convert(codeTextField.bounds, to: view)
        height = (textFieldInView.origin.y + textFieldInView.size.height) - frameHeight + containerViewVerticalCenterConstraint.constant
        containerViewVerticalCenterConstraint.constant = -(height + 6)
        UIView.animate(withDuration: animationDurarion, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        containerViewVerticalCenterConstraint.constant = 0
        UIView.animate(withDuration: animationDurarion, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
