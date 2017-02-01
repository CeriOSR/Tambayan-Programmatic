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

class EventsCollectionCell: BaseCell {
    
    var events: Events? {
        
        didSet{
            eventNameLabel.text = events?.eventTitle
            
            if let eventCachedImage = events?.eventImageName {
                eventImage.loadEventImageUsingCacheWithUrlString(urlString: eventCachedImage)
            }
            
            if let unixDate = events?.eventDate {
                guard let timeIntervalDate = TimeInterval(unixDate) else {return}
                let dateToBeFormattedForDisplay = Date(timeIntervalSince1970: timeIntervalDate)
                let formattedDate = DateFormatter.localizedString(from: dateToBeFormattedForDisplay, dateStyle: .full, timeStyle: .long)
                
                eventDateLabel.text = formattedDate
            }
        }
    }
    
    let eventImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .brown
        return image
    }()
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let eventDateLabel: UILabel = {
        let label = UILabel()
        label.text = String(describing: Date())
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(eventImage)
        addSubview(eventNameLabel)
        addSubview(eventDateLabel)
        
        addConstraintsWithFormat(format: "H:|-2-[v0(80)]-4-[v1]|", views: eventImage, eventNameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: eventImage)
        addConstraintsWithFormat(format: "V:|[v0(40)]", views: eventNameLabel)
        addConstraintsWithFormat(format: "H:|-2-[v0(80)]-4-[v1]|", views: eventImage, eventDateLabel)
        addConstraintsWithFormat(format: "V:[v0(35)]|", views: eventDateLabel)
    }
    
}


