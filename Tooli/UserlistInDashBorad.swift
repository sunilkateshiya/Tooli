//
//  UserlistInDashBorad.swift
//  Tooli
//
//  Created by Impero IT on 18/05/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit

class UserlistInDashBorad: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {

    
    override func awakeFromNib() {
        super.awakeFromNib()
       // collection.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "UserList")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserList", for: indexPath) as! UserCollectionViewCell
       // return cell
        
        return UICollectionViewCell()
    }
}
