//
//  Shadow+Rounding.swift
//  iOS-frameworks
//
//  Created by Vit K on 17.02.2021.
//

import UIKit

 class LightShadow: UIView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    var shadowLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    
    @IBInspectable var color: UIColor = .red {
        didSet { self.updateColors() }
    }
    @IBInspectable var opacity: CGFloat = 1 {
        didSet { self.updateOpacity() }
    }
    @IBInspectable var radius: CGFloat = 7 {
        didSet { self.udateRadius() }
    }
    @IBInspectable var offset: CGSize = .zero {
        didSet { self.updateOffset() }
    }
    
  
        
    func updateColors() {
        self.shadowLayer.shadowColor = self.color.cgColor
    }
    func updateOpacity() {
        self.shadowLayer.shadowOpacity = Float(self.opacity)
    }
    func udateRadius() {
        self.shadowLayer.shadowRadius = self.radius
    }
    func updateOffset() {
        self.shadowLayer.shadowOffset = offset
    }
}

class DarkShadow: UIView {
   override class var layerClass: AnyClass {
         return CAShapeLayer.self
     }

   var shadowLayer1: CAShapeLayer {
       return self.layer as! CAShapeLayer
   }


   @IBInspectable var color1: UIColor = .red {
       didSet { self.updateColors1() }
   }
   @IBInspectable var opacity1: CGFloat = 1 {
       didSet { self.updateOpacity1() }
   }
   @IBInspectable var radius1: CGFloat = 7 {
       didSet { self.udateRadius1() }
   }
   @IBInspectable var offset1: CGSize = .zero {
       didSet { self.updateOffset1() }
   }



   func updateColors1() {
       self.shadowLayer1.shadowColor = self.color1.cgColor
   }
   func updateOpacity1() {
       self.shadowLayer1.shadowOpacity = Float(self.opacity1)
   }
   func udateRadius1() {
       self.shadowLayer1.shadowRadius = self.radius1
   }
   func updateOffset1() {
       self.shadowLayer1.shadowOffset = offset1
   }
}

 class Roundinng: UIButton {
    
    override class var layerClass: AnyClass {
          return CAShapeLayer.self
      }
      var roundedLayer: CAShapeLayer {
          return self.layer as! CAShapeLayer
      }

    
    @IBInspectable var color: UIColor = .lightGray {
           didSet { self.updateColors() }
       }
    @IBInspectable var borderWidth: CGFloat = 3 {
        didSet { self.updateWidth() }
    }
    @IBInspectable var radius: CGFloat = 25 {
        didSet { self.udateRadius() }
    }
    
    
    
    func updateColors() {
        self.roundedLayer.borderColor = self.color.cgColor
    }
    func updateWidth() {
        self.roundedLayer.borderWidth = self.borderWidth
    }
    func udateRadius() {
        self.roundedLayer.cornerRadius = self.radius
    }
 }
