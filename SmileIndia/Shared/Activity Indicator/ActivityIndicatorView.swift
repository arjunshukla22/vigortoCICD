//
//  ActivityIndicatorView.swift
//  XRentY
//
//  Created by user on 08/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

enum Loader {
    case simple
    case text
}

final class ActivityIndicatorView: UIView {

    class func instanceFromNib() -> ActivityIndicatorView {
        return UINib(nibName: "ActivityIndicator", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ActivityIndicatorView
    }
    
    var isSpinnerAnimating: Bool {
        return spinner.isAnimating
    }
    
    @IBOutlet private var spinner: UIActivityIndicatorView!

    
    public func startLoading() {
        spinner.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
        spinner.style = .whiteLarge
        spinner.color = .themeGreen
        spinner.startAnimating()
    }
    
    public func stopLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}
