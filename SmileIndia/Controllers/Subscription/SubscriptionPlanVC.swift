//
//  SubscriptionPlanVC.swift
//  SmileIndia
//
//  Created by Arjun  on 25/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SubscriptionPlanVC: UIViewController , UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var movies: [String] = ["background","gradient","welcomescreen"]
    var frame = CGRect.zero
    
    var bgclr = [.themeGreen,#colorLiteral(red: 0.9900509715, green: 0.6966494322, blue: 0.1693406701, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
    
    var dataArray = [["A","B","C"],["D","E","F"],["G","H","I"]]
    var newArray = [String]()
    
    let tableView = UITableView()
    let tableView1 = UITableView()
    let tableView2 = UITableView()
    
    var tvArray:[UITableView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

        pageController.numberOfPages = movies.count

        scrollView.delegate = self
        
        tvArray.append(tableView)
        tvArray.append(tableView1)
        tvArray.append(tableView2)
        
        setupScreens()

    }
    func setupScreens() {
        for index in 0..<movies.count {
            // 1.
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size

            
            // 2.
            let imgView = UIImageView(frame: frame)
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: movies[index])
            
            //2 for table view
            var table = UITableView()
            tvArray[index].frame = frame
            table = tvArray[index]
            table.backgroundColor = bgclr[index]
            table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            table.dataSource = self
            table.delegate = self
            self.scrollView.addSubview(table)
        }

        // 3.
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(movies.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageController.currentPage = Int(pageNumber)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(newArray[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return dataArray[0].count
        }else if tableView == self.tableView1 {
            return dataArray[1].count
        }else{
            return dataArray[2].count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if tableView == self.tableView {
            cell.textLabel!.text = "\(dataArray[0][indexPath.row])"
        }else if tableView == self.tableView1 {
            cell.textLabel!.text = "\(dataArray[1][indexPath.row])"
        }else{
            cell.textLabel!.text = "\(dataArray[2][indexPath.row])"
        }
        return cell
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapMonth(_ sender: Any) {
    }
    
    @IBAction func didtapAnual(_ sender: Any) {
    }
}
