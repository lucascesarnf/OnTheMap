//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 05/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: GenericViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    //This set white status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoginButton()
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: Actions
    @IBAction func tapToDismisskeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func singUpAction(_ sender: UIButton) {
        UIApplication.shared.open(UdacityUtils.shared.accountAuthSingupURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        view.endEditing(true)
        guard let email = emailLabel.text, let password = passwordLabel.text else { return }
        loader.startAnimation(self)
        loginService.requestSession(username: email, password: password) { results in
            switch results {
            case .Success(let client):
                UdacityUtils.shared.setClient(client: client)
                self.getLocations() {
                    self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                }
            case .Failure(let error):
                var errorMessage = ""
                if let loginError = error as? ServiceError {
                    errorMessage = loginError.error
                } else {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(errorMessage)
            }
        }
    }
    
    private func setLoginButton() {
        guard let email = emailLabel.text, let password = passwordLabel.text else { return }
        let shouldShow = email.count > 0 && password.count > 0
        loginButton.isEnabled = shouldShow
        loginButton.alpha = shouldShow ? 1 : 0.5
    }
}


// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate  {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        emailLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordLabel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        passwordLabel.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailLabel.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setLoginButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
}
