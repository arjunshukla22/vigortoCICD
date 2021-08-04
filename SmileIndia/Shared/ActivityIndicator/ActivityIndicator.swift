//
//  ActivityIndicator.swift
//  HandstandV2
//
//  Created by user on 01/02/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator: NSObject {
    
    static let sharedInstance = ActivityIndicator()
    lazy private var loaderView: ActivityIndicatorView = {
        let view  = ActivityIndicatorView.instanceFromNib()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.clipsToBounds = true
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    var isLoaderAnimating : Bool! {
        return loaderView.isSpinnerAnimating
    }
    
    func hideLoader() {
            self.loaderView.stopLoading()
            self.loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.loaderView.removeFromSuperview()
    }
    
    func showLoaderOnWindow() {
        guard let window = UIApplication.shared.delegate?.window else { return }
        self.loaderView.startLoading()
        window?.addSubview(loaderView)
    }
    
}
var activityIndicator = ActivityIndicator.sharedInstance
