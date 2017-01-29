//
//  CollectionViewCells.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-26.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

class EventCategoryCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let categoryLabel: UILabel = {
        let cl = UILabel()
        cl.text = "Categories"
        cl.textAlignment = .center
        cl.textColor = .white
        cl.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        cl.font = UIFont.boldSystemFont(ofSize: 16)
        return cl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(categoryLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: categoryLabel)
        addConstraintsWithFormat(format: "V:[v0(50)]|", views: categoryLabel)
    }
}

