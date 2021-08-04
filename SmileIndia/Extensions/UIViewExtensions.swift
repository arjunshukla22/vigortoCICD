//
//  UIViewExtensions.swift
//  HandstandV2
//
//  Created by user on 18/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
    get {
    return layer.cornerRadius
    }
    set {
    layer.cornerRadius = newValue
    layer.masksToBounds = newValue > 0
    }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
            let backgroundView = UIView()
            backgroundView.frame = UIScreen.main.bounds
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            backgroundView.tag = 475647
            
            let loadingView: UIView = UIView()
            loadingView.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
            loadingView.center = backgroundView.center
            loadingView.backgroundColor = backgroundColor
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
            activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            activityIndicator.hidesWhenStopped = true
            activityIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.color = activityColor
            activityIndicator.startAnimating()
            self.isUserInteractionEnabled = false
            
                    var imageView : UIImageView
                    imageView  = UIImageView(frame:CGRect(x: 15, y: 15, width: 60, height: 60));
                    imageView.image = UIImage.gif(name: "vigorto-loader")
                    loadingView.addSubview(imageView)
           // loadingView.addSubview(activityIndicator)
            backgroundView.addSubview(loadingView)
            self.addSubview(backgroundView)
        }
        
        func activityStopAnimating() {
            DispatchQueue.main.async {
                if let background = self.viewWithTag(475647){
                    background.removeFromSuperview()
                }
                self.isUserInteractionEnabled = true
            }
    }
}
