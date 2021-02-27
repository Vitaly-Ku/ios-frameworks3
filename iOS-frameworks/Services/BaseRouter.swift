//
//  BaseRouter.swift
//  iOS-frameworks
//
//  Created by Vit K on 26.02.2021.
//

import UIKit

class BaseRouter {
    var controller: UIViewController!
    
    init(vc: UIViewController) {
        self.controller = vc
    }
    final func present(vc: UIViewController, animated : Bool = true, completion: (() -> Void)? = nil) {
        controller.present(vc, animated: animated, completion: completion)
    }
    
    final func push(vc: UIViewController, animated : Bool = true) {
        controller.navigationController?.pushViewController(vc, animated: animated)
    }
    
    final func dismiss(animated : Bool = true, completion: (() -> Void)? = nil) {
        controller.dismiss(animated: animated, completion: completion)
    }
}
