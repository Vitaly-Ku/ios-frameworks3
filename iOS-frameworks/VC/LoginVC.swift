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
    var onTakePicture: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRouter = LoginRouter(vc: self)
        loginBinding()
    }
    
    // MARK: - Actions
    
    @IBAction func takePicture(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        // Создаём контроллер и настраиваем его
        let imagePickerController = UIImagePickerController()
        // Источник изображений: камера
        imagePickerController.sourceType = .photoLibrary
        // Изображение можно редактировать
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        // Показываем контроллер
        present(imagePickerController, animated: true)
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
    func toMain(image : UIImage? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.img = image
        push(vc: vc)
    }
    func toRegister() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        present(vc: vc)
    }
}

extension LoginVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) { [weak self] in
            guard let img = self?.extractImage(from: info) else  { return }
            //сохраняем в галерею
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
            //открываем карту
            self?.loginRouter.toMain(image: img)
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Ошибка сохранения", message: error.localizedDescription)
        } else {
            showAlert(title: "Успешно!", message: "Изображение сохранено в галерею!")
        }
    }
}
