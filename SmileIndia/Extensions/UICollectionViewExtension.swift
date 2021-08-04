//
//  UICollectionViewExtension.swift
//  SmileIndia
//
//  Created by Arjun  on 05/08/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
