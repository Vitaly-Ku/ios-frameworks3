//
//  UIButton.swift
//  iOS-frameworks
//
//  Created by Vit K on 17.02.2021.
//

import UIKit

extension UIButton {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.1, y: 0.6)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.95
        pulse.toValue = 1
        //        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.4
        pulse.damping = 3
        pulse.mass = 1// default 1
        pulse.stiffness = 333 // default 100
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.2
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
}
