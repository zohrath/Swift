//
//  LoginAndRegisterViewController.swift
//  iList Ambassador
//
//  Created by Mathias Palm on 2016-05-14.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices
import Crashlytics

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LoginAndRegisterViewController: BaseViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var registerViewButton: UIButton!
    @IBOutlet weak var loginViewButton: UIButton!
    @IBOutlet weak var facebookButtonPlaceholder: UIView!
    @IBOutlet weak var facebookButtonPlaceholderLogin: UIView!
    
    lazy var facebookLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton(type: UIButtonType.custom)
        button.loginBehavior = FBSDKLoginBehavior.native
        button.delegate = self
        button.readPermissions = ["public_profile", "email"]
        self.facebookButtonPlaceholder.addSubview(button)
        return button
    }()
    
    lazy var facebookLoginButtonLogin: FBSDKLoginButton = {
        let button = FBSDKLoginButton(type: UIButtonType.custom)
        button.loginBehavior = FBSDKLoginBehavior.native
        button.delegate = self
        button.readPermissions = ["public_profile", "email"]
        self.facebookButtonPlaceholderLogin.addSubview(button)
        return button
    }()
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginScrollView: UIScrollView!
    
    @IBOutlet weak var errorLabel: ErrorLabel!
    var showLostPassword = false
    
    private let fbLoginManager = FBSDKLoginManager()
    
    // Login Outlets
    @IBOutlet weak var loginEmailTextField: TextField!
    @IBOutlet weak var loginPasswordTextField: TextField!
    @IBOutlet weak var loginDoneButton: Button!
    @IBOutlet weak var loginOrLabel: UILabel!
    
    // Register Outlets
    @IBOutlet weak var registerEmailTextField: TextField!
    @IBOutlet weak var registerPasswordTextField: TextField!
    @IBOutlet weak var registerConfirmPasswordTextField: TextField!
    @IBOutlet weak var registerFirstNameTextField: TextField!
    @IBOutlet weak var registerLastNameTextField: TextField!
    @IBOutlet weak var registerBirthYearTextField: TextField!
    @IBOutlet weak var registerOrLabel: UILabel!
    @IBOutlet weak var registerEmailDoneButton: Button!
    
    @IBOutlet weak var registerBirthBackButton: Button!
    @IBOutlet weak var registerBirthDoneButton: Button!
    
    enum LoginViewStyle {
        case login
        case register
    }
    enum RegisterView {
        case emailAndPassword
        case birthYear
    }
    
    var activeTextField = 0
    var loginViewStyle: LoginViewStyle = .login
    var currentRegisterView: RegisterView = .emailAndPassword
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = backgroundImageView.image {
            let i = resizeImage(image)
            backgroundImageView.image = i
            backgroundImageWidthConstraint.constant = i.size.width
            view.layoutIfNeeded()
        }
        
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(LoginAndRegisterViewController.resignTextField(_:)))
        view.addGestureRecognizer(backgroundTap)
        
        registerBirthYearTextField.placeholder = "\(Date().year())"
        
        registerBirthYearTextField.layer.borderWidth = 2
        birthYearFrame(Color.purpleColor())
        
        forgotPasswordButton.titleLabel?.font = Font.normalFont(FontSize.Large)
        forgotPasswordButton.setTitleColor(Color.whiteColor(), for: UIControlState())
        forgotPasswordButton.setTitle(NSLocalizedString("FORGOT_PASSWORD", comment: ""), for: UIControlState())
        loginDoneButton.setTitle(NSLocalizedString("LOGIN", comment: ""), for: UIControlState())
        registerEmailDoneButton.setTitle(NSLocalizedString("NEXT", comment: ""), for: UIControlState())
        registerBirthDoneButton.setTitle(NSLocalizedString("REGISTER", comment: ""), for: UIControlState())
        registerBirthBackButton.setTitle(NSLocalizedString("BACK", comment: ""), for: UIControlState())
        
        loginEmailTextField.placeholder = NSLocalizedString("EMAIL", comment: "")
        loginPasswordTextField.placeholder = NSLocalizedString("PASSWORD", comment: "")
        
        loginEmailTextField.autocorrectionType = .no
        loginEmailTextField.autocapitalizationType = .none
        loginPasswordTextField.autocorrectionType = .no
        loginPasswordTextField.autocapitalizationType = .none
        
        registerViewButton.setTitle(NSLocalizedString("REGISTER", comment: ""), for: UIControlState())
        loginViewButton.setTitle(NSLocalizedString("LOGIN", comment: ""), for: UIControlState())
        
        loginOrLabel.text = NSLocalizedString("OR", comment: "")
        registerOrLabel.text = NSLocalizedString("OR", comment: "")
        
        updateWithLoginViewStyle(.login)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginAndRegisterViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginAndRegisterViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.current() != nil {
            UserManager.sharedInstance.fetchFacebookUserInfo({ [weak self] (user, error) in
                if let user = user {
                    self?.handleSuccessfullyAuthenticatedWithUser(user)
                } else if let error = error {
                    debugPrint("FB Login: fetchFacebookUserInfo error: \( error.localizedDescription )")
                    // Logout if not successfully logged in
                    self?.fbLoginManager.logOut()
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        facebookLoginButton.frame = facebookButtonPlaceholder.bounds
        facebookLoginButtonLogin.frame = facebookButtonPlaceholderLogin.bounds
    }
    
    func resizeImage(_ image:UIImage) -> UIImage {
        let screenHeight = SCREENSIZE.height
        let screenWidth = SCREENSIZE.width
        let ratio = screenWidth / screenHeight
        
        let newWidth = ratio * image.size.width
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: screenHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: screenHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillHide)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillShow)
    }

    // MARK: - Actions
    
    @IBAction func loginViewButtonPressed(_ sender: UIButton) {
        updateWithLoginViewStyle(.login)
    }

    @IBAction func registerViewButtonPressed(_ sender: UIButton) {
        updateWithLoginViewStyle(.register)
    }
    @IBAction func textFieldIsActive(_ sender: UITextField) {
        hideErrorLabel()
        activeTextField = sender.tag
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        resignTextFields()
        if loginViewStyle == .login {
            login(loginEmailTextField.text, password: loginPasswordTextField.text)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        scrollToNextContent(false)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        var goToNext = false
        switch currentRegisterView {
        case .emailAndPassword:
            goToNext = checkPasswordAndEmail()
            if !goToNext {
                self.showErrorLabelWithText(NSLocalizedString("PASSWORD_DOES_NOT_MATCH", comment: ""))
            }
        case .birthYear:
            goToNext = false
            if registerBirthYearTextField.text?.characters.count != 4 {
                birthYearFrame(Color.redColor())
            } else {
                registerNewUser()
            }
        }
        if goToNext {
            scrollToNextContent(true)
        }
    }
    
    @IBAction func termsAndConditionsButtonTapped(_ sender: AnyObject?) {
        let urlString = NSLocalizedString("URL_AGREEMENTS", comment: "")
        if let url = URL(string: urlString) {
            if #available(iOS 9.0, *) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            // TODO: Statistics send log event for url opened
        }
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: AnyObject?) {
        showLostPassword = true
        var inputTextField: UITextField?
        let passwordPrompt = UIAlertController(title: NSLocalizedString("FORGOT_PASSWORD", comment: ""), message: NSLocalizedString("FORGOT_PASSWORD_MESSAGE", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        passwordPrompt.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
            self.showLostPassword = false
        }))
        passwordPrompt.addAction(UIAlertAction(title: NSLocalizedString("RESET", comment: ""), style: UIAlertActionStyle.default, handler: { (_) -> Void in
            if let emailField =  inputTextField {
                self.resetPassword(emailField)
            }
            self.showLostPassword = false
        }))
        passwordPrompt.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = NSLocalizedString("EMAIL", comment: "")
            textField.keyboardType = UIKeyboardType.emailAddress
            inputTextField = textField
            inputTextField?.text = self.loginEmailTextField.text
        })
        
        present(passwordPrompt, animated: true, completion: nil)
    }
    
    // MARK: - Login
    
    fileprivate func login(_ username: String?, password: String?) {
        guard let username = username else {
            print("no username")
            return
        }
        
        guard let password = password else {
            print("no password")
            return
        }
        loginDoneButton.startLoading()
        UserManager.sharedInstance.authenticateWithUsername(username, password: password) { (user, error) in
            if let user = user {
                self.handleSuccessfullyAuthenticatedWithUser(user)
            } else if let error = error {
                self.handleFailedAuthenticationWithError(error)
            }
        }
    }
    
    fileprivate func registerNewUser() {
        var param = [
            "email" : registerEmailTextField.text!,
            "password" : registerPasswordTextField.text!
        ]
        
        if registerFirstNameTextField.text?.characters.count > 0 {
            param["first_name"] = registerFirstNameTextField.text!
        }
        
        if registerLastNameTextField.text?.characters.count > 0 {
            param["last_name"] = registerLastNameTextField.text!
        }
        
        let date = "\(registerBirthYearTextField.text!)-12-30"
        param["birth_date"] = "\(date)"
        
        register(param)
    }
    
    fileprivate func register(_ param: [String:String]) {
        resignTextFields()
        registerBirthDoneButton.startLoading()
        UserManager.sharedInstance.registerWithUsername(param) { (user, error) in
            if let user = user {
                UserManager.sharedInstance.authenticateWithUsername(user.email, password: param["password"]!) { (user, error) in
                    if let user = user {
                        self.handleSuccessfullyAuthenticatedWithUser(user)
                    } else if let error = error {
                        self.handleFailedAuthenticationWithError(error)
                    }
                }
            } else if let error = error {
                self.scrollToNextContent(false)
                self.handleFailedAuthenticationWithError(error)
            }
        }
    }
    
    fileprivate func handleSuccessfullyAuthenticatedWithUser(_ user: User) {
        DispatchQueue.main.async(execute: {
            print("handleSuccessfullyAuthenticatedWithUser: \( user.email )")
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.navigateToApplication()
            }
            self.registerBirthDoneButton.stopLoading()
            self.loginDoneButton.stopLoading()
        })
    }
    
    fileprivate func handleFailedAuthenticationWithError(_ error: Error) {
        DispatchQueue.main.async(execute: {
            Crashlytics.sharedInstance().recordError(error)
            self.registerBirthDoneButton.stopLoading()
            self.loginDoneButton.stopLoading()
            self.showErrorLabelWithText(NSLocalizedString("UNABLE_TO_LOGIN", comment: ""))
        })
    }
    
    fileprivate func handleSuccessfullyResetPassword() {
        DispatchQueue.main.async(execute: {
            let passwordPrompt = UIAlertController(title: NSLocalizedString("FORGOT_PASSWORD_SUCCESS", comment: ""), message:nil, preferredStyle: UIAlertControllerStyle.alert)
            passwordPrompt.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
            self.present(passwordPrompt, animated: true, completion: nil)
            
        })
    }
    
    fileprivate func handleFailedResetPassword(_ error: Error) {
        DispatchQueue.main.async(execute: {
            Crashlytics.sharedInstance().recordError(error)
            self.showErrorLabelWithText(NSLocalizedString("UNABLE_TO_RESET_PASSWORD", comment: ""))
        })
    }

    // MARK: - Helpers
    
    func birthYearFrame(_ color:UIColor) {
        registerBirthYearTextField.layer.borderColor = color.cgColor
    }
    
    func checkPasswordAndEmail() -> Bool {
        guard registerEmailTextField.text?.characters.count > 0 && registerPasswordTextField.text?.characters.count > 0 && registerConfirmPasswordTextField.text?.characters.count > 0 else {
            self.showErrorLabelWithText(NSLocalizedString("ENTER_ALL_REGISTER_FIELDS", comment: ""))
            return false
        }
        return registerPasswordTextField.text == registerConfirmPasswordTextField.text
    }
    
    func scrollToNextContent(_ right:Bool) {
        resignTextFields()
        let screenWidth = view.frame.size.width
        if let image = backgroundImageView.image {
            let imageOffset = image.size.width - screenWidth
            backgroundImageLeadingConstraint.constant -= (right ? imageOffset : -imageOffset) / 4
        }
        let contentOffset = loginScrollView.contentOffset.x + (right ? screenWidth : -screenWidth)
        switch contentOffset {
        case 0.0:
            currentRegisterView = .emailAndPassword
        case screenWidth:
            currentRegisterView = .birthYear
        default:
            break
        }
        loginScrollView.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: true)
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func resignTextField(_ tap: UITapGestureRecognizer) {
        resignTextFields()
    }
    
    func resignTextFields() {
        hideErrorLabel()
        loginEmailTextField.resignFirstResponder()
        loginPasswordTextField.resignFirstResponder()
        registerEmailTextField.resignFirstResponder()
        registerPasswordTextField.resignFirstResponder()
        registerConfirmPasswordTextField.resignFirstResponder()
        registerFirstNameTextField.resignFirstResponder()
        registerLastNameTextField.resignFirstResponder()
        registerBirthYearTextField.resignFirstResponder()
    }
    
    func updateWithLoginViewStyle(_ loginViewStyle: LoginViewStyle) {
        
        resignTextFields()
        self.loginViewStyle = loginViewStyle
        
        loginViewButton.titleLabel?.font = (loginViewStyle == .login) ? Font.titleFont(FontSize.SuperLarge) : Font.semiTitleFont(FontSize.SuperLarge)
        registerViewButton.titleLabel?.font = (loginViewStyle == .register) ? Font.titleFont(FontSize.SuperLarge) : Font.semiTitleFont(FontSize.SuperLarge)
        
        loginViewButton.setTitleColor((loginViewStyle == .login) ? Color.whiteColor() : Color.lightGrayColor(),for: UIControlState())
        registerViewButton.setTitleColor((loginViewStyle == .register) ? Color.whiteColor() : Color.lightGrayColor(),for: UIControlState())
        
        if loginViewStyle == .login { forgotPasswordButton.isHidden = false } else { forgotPasswordButton.isHidden = true }
        if loginViewStyle == .login { loginView.isHidden = false } else { loginView.isHidden = true }
        if loginViewStyle == .register { registerView.isHidden = false } else { registerView.isHidden = true }
    }
    
    func resetPassword(_ textField:UITextField) {
        if let email = textField.text {
            UserManager.sharedInstance.restorePasswordWithEmail(email, completion: { (success, error) in
                if success {
                    self.handleSuccessfullyResetPassword()
                } else if let error = error {
                    self.handleFailedResetPassword(error)
                }
            })
        }
    }
    
    // MARK: - Error handling
    
    fileprivate func hideErrorLabel() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
    
    fileprivate func showErrorLabelWithText(_ errorText: String) {
        errorLabel.text = errorText
        errorLabel.isHidden = false
    }

}

extension LoginAndRegisterViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailTextField {
            loginPasswordTextField.becomeFirstResponder()
            return true
        } else if textField == loginPasswordTextField {
            dismissKeyboard()
            return true
        }
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        nextTextFieldOrSubmit(nextTag)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
    func nextTextFieldOrSubmit(_ tag:Int) {
        switch loginViewStyle {
        case .login:
            if tag == 2 {
                loginPasswordTextField.becomeFirstResponder()
            } else {
                login(loginEmailTextField.text, password: loginPasswordTextField.text)
            }
        case .register:
            switch tag {
            case 5:
                registerPasswordTextField.becomeFirstResponder()
            case 6:
                registerConfirmPasswordTextField.becomeFirstResponder()
            case 7:
                scrollToNextContent(true)
            case 10:
                registerLastNameTextField.becomeFirstResponder()
            case 11:
                registerBirthYearTextField.becomeFirstResponder()
            default:
                break
            }
        }
    }
    func keyboardWillShow(_ notification: Notification) {
        if !showLostPassword {
            let userInfo = notification.userInfo!
            let keyboardHeight = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let frameHeight = view.frame.size.height - keyboardHeight
            var height:CGFloat = 0
            if let actView = view.viewWithTag(activeTextField+1) {
                let textFieldInView = actView.convert(actView.bounds, to: view)
                height = (textFieldInView.origin.y + textFieldInView.size.height) - frameHeight + contentViewBottomConstraint.constant
            }
            contentViewBottomConstraint.constant = height + 6
            UIView.animate(withDuration: animationDurarion, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        contentViewBottomConstraint.constant = 0
        UIView.animate(withDuration: animationDurarion, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension LoginAndRegisterViewController: FBSDKLoginButtonDelegate {

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // Do nothing
        print("loginButtonDidLogOut")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("loginButtonWillLogin")
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("didCompleteWithResult")
        if error != nil {
            debugPrint("FB Login Error: \( error.localizedDescription )")
        } else if result.isCancelled {
            debugPrint("FB Login Error: Login was cancelled")
        } else {
            UserManager.sharedInstance.fetchFacebookUserInfo({ (user, error) in
                if let user = user {
                    self.handleSuccessfullyAuthenticatedWithUser(user)
                } else if let error = error {
                    debugPrint("FB Login Error: fetchFacebookUserInfo: \(error.localizedDescription)")
                }
            })
        }
    }
    
}
