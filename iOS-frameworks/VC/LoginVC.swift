//
//  LoginVC.swift
//  iOS-frameworks
//
//  Created by Vit K on 26.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    
    var loginRouter: LoginRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRouter = LoginRouter(vc: self)
        loginBinding()
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isLogin")
        guard let login = loginTF.text, let password = passwordTF.text else {
            return
        }
        authorize(login: login, password: password)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        loginRouter.toRegister()
    }
    
    // MARK: - Authorize

    func authorize(login : String, password : String){
        let dataFromRealm : [User] = RealmService.getDataFromRealm(with: "login == '\(login)' AND password == '\(password)'")
        
        if dataFromRealm.isEmpty {
            self.showAlert(title: "Ошибка", message: "Неверные данные")
        } else {
            loginRouter.toMain()
        }
    }
    
    // MARK: - RX
    
    func loginBinding() {
        Observable.combineLatest(
            loginTF.rx.text,
            passwordTF.rx.text
        ).map { login, password in
            return !(login ?? "").isEmpty && (password ?? "").count >= 3
        }.bind { [weak enterBtn] inputFilled in
            enterBtn?.isEnabled = inputFilled
            enterBtn?.setTitleColor(inputFilled ? UIColor.systemBlue : UIColor.gray, for: .normal)
        }
    }
}

// MARK: - Router

final class LoginRouter: BaseRouter {
    func toMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        push(vc: vc)
    }
    func toRegister() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        present(vc: vc)
    }
}
