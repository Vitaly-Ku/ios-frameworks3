//
//  LoginVC.swift
//  iOS-frameworks
//
//  Created by Vit K on 26.02.2021.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var loginRouter: LoginRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRouter = LoginRouter(vc: self)
    }
    
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

    func authorize(login : String, password : String){
        let dataFromRealm : [User] = RealmService.getDataFromRealm(with: "login == '\(login)' AND password == '\(password)'")
        
        if dataFromRealm.isEmpty {
            self.showAlert(title: "Ошибка", message: "Неверные данные")
        } else {
            loginRouter.toMain()
        }
    }   
}

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
