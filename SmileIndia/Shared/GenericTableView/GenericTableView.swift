//
//  GenericTableView.swift
//  HandstandV2
//
//  Created by user on 03/01/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T: UITableViewCell>: NSObject , UITableViewDataSource, UITableViewDelegate {
    var didSelect: (T, Int) -> () = { _,_ in }
    let screenSize: CGRect = UIScreen.main.bounds
    var didScroll: () -> () = { }
    var configure : ((T, Int) -> ())?
    var identifier = String()
    var nib = UINib()
    var isScrolled = Bool()
    var array: [Any] = []
    
    func registerCells(forTableView tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func loadCell(atIndexPath indexPath: IndexPath, forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configure?(cell as! T, indexPath.row)
        return cell
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array.count == 0 {
            tableView.setEmptyMessage(AlertBtnTxt.norecordsFound.localize())
         } else {
             tableView.restore()
         }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.loadCell(atIndexPath: indexPath, forTableView: tableView)
    }
    

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)      {
        let cell = tableView.cellForRow(at: indexPath)
        didSelect(cell as! T, indexPath.row)
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollheight = scrollView.contentOffset.y + scrollView.frame.size.height
        let scrollContentHeight = scrollView.contentSize.height-10
        
      //  print(" Scroll Height :- \(scrollheight) \n Content height :- \(scrollContentHeight)")
        
        if scrollheight > scrollContentHeight
        {
            didScroll()
            isScrolled = true
        }
    }
}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let imageView1 = UIImageView()
        imageView1.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView1.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView1.image = nil
        //Image View
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView.image = #imageLiteral(resourceName: "notfound")

        //Text Label
        let textLabel = UILabel()
        textLabel.widthAnchor.constraint(equalToConstant: self.bounds.size.width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        textLabel.text  = message
        textLabel.textAlignment = .center
        textLabel.font = .boldSystemFont(ofSize: 14)
        textLabel.numberOfLines = 0


        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10.0
        
        stackView.addArrangedSubview(imageView1)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundView = stackView
   /*       let viewDemo = UIView()
          viewDemo.frame =  CGRect(x: 0 , y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
          viewDemo.contentMode = .center
        let messageimage = UIImageView()
         messageimage.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
         messageimage.contentMode = .center
         messageimage.image = #imageLiteral(resourceName: "notfound")
           let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
           messageLabel.text = message
           messageLabel.textColor = .none
           messageLabel.numberOfLines = 0
           messageLabel.textAlignment = .center
           messageLabel.font = UIFont(name: "Lato-Black", size: 18)
           messageLabel.sizeToFit()
           viewDemo.addSubview( messageLabel)
           viewDemo.addSubview(messageimage)
        self.backgroundView = viewDemo */
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
