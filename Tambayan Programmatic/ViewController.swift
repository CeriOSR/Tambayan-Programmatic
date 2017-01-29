//
//  ViewController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-24.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class EventsCategoryCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categories = ["Sports", "Music", "Food", "Tech", "Education", "Business", "Outdoors", "Lazy Sunday", "Misc."]
    //let categoriesImage: [UIImage]?
    let loginController = LoginController()
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForLoggedInUser()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        collectionView?.backgroundColor = .white
        collectionView?.register(EventCategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForLoggedInUser()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCategoryCell
        
        cell.categoryLabel.text = categories[indexPath.item]
        cell.imageView.image = UIImage(named: "ringo")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 75, left: 20, bottom: 75, right: 20)
    }

    func handleLogout() {
        
        //facebook login manager
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        
        
        present(loginController, animated: true, completion: nil)
        
    }
    
    func checkForLoggedInUser() {
        
        let userId = FIRAuth.auth()?.currentUser?.uid
        
        if userId == nil {
            present(loginController, animated: true, completion: nil)
            
        }
    }

}

    


