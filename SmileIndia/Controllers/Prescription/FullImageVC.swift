//
//  FullImageVC.swift
//  SmileIndia
//
//  Created by Arjun  on 19/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class FullImageVC: UIViewController, UIScrollViewDelegate{
    
    var image: URL?
    var titleStr = ""
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.img.sd_setImage(with: image , placeholderImage: nil)
        
        self.titleLabel.text = titleStr
        
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 6.0
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
          return img
      }
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @objc func zoomingImage(sender:UIPinchGestureRecognizer)  {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
}
