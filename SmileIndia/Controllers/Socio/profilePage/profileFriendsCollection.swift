//
//  profileFriendsCollection.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 10/05/21.
//  Copyright © 2021 Na. All rights reserved.
//



import UIKit

class profileFriendsCollection: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! profileFriendsCollectionViewCell
        
        return cell
    }

}
