//
//  EventsCollectionViewController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-28.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit
import Firebase


class EventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var events = [Events]()
    var category: String? {
        didSet{
            navigationItem.title = category
            
        }
    }
    
    var eventsCategoryController = EventsCategoryCollectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
        self.collectionView!.register(EventsCollectionCell.self, forCellWithReuseIdentifier: cellId)
        fetchEventsInCategory()
        collectionView?.reloadData()

    }

        override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventsCollectionCell
        let event = events[indexPath.row]
        cell.events = event
        //cell.eventNameLabel.text = event.eventTitle
        print(event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchEventsInCategory() {
        
        guard let eCategory = category else {return}
        let ref = FIRDatabase.database().reference().child("categories").child("\(eCategory)")
        ref.observe(.childAdded, with: { (snapshot) in
            
            let eventId = snapshot.key
            let eventRef = FIRDatabase.database().reference().child("events").child("\(eventId)")
            eventRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
                print(dictionary)
                let fetchedEvents = Events()
                //fetchedEvents.setValuesForKeys(dictionary) //might crash if keys dont match
                
                fetchedEvents.eventTitle = dictionary["title"] as? String
                fetchedEvents.eventDescription = dictionary["desc"] as? String
                fetchedEvents.eventLocation = dictionary["location"] as? String
                fetchedEvents.eventImageName = dictionary["image"] as? String
                fetchedEvents.eventDate = dictionary["date"] as? String
                fetchedEvents.eventType = dictionary["category"] as? String
                
                self.events.append(fetchedEvents)
                print(self.events)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
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















