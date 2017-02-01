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
        
        tabBarController?.tabBar.isHidden = false
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
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eventDetailsController = EventDetailsController()
        eventDetailsController.event = events[indexPath.item]
        eventDetailsController.eventsCollectionViewController = self
        let navController = UINavigationController(rootViewController: eventDetailsController)
        present(navController, animated: true, completion: nil)
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
                let fetchedEvents = Events()
                //fetchedEvents.setValuesForKeys(dictionary) //might crash if keys dont match
                
                fetchedEvents.eventTitle = dictionary["title"] as? String
                fetchedEvents.eventDescription = dictionary["desc"] as? String
                fetchedEvents.eventLocation = dictionary["location"] as? String
                fetchedEvents.eventImageName = dictionary["image"] as? String
                fetchedEvents.eventDate = dictionary["date"] as? String
                fetchedEvents.eventType = dictionary["category"] as? String
                
                self.events.append(fetchedEvents)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
}
















