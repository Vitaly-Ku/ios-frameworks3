//
//  RegisterVC.swift
//  iOS-frameworks
//
//  Created by Vit K on 26.02.2021.
//

import UIKit

class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonWasTapped(_ sender: UIButton) {
        let user = User()
        user.login = loginTF.text
        user.password = passwordTF.text
        RealmService.saveDataToRealm(user)
    }

}
