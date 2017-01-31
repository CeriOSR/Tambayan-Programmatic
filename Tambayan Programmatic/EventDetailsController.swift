//
//  EventDetailsController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-31.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit
import Firebase
import FBSDKShareKit
import EventKit
import EventKitUI
import Social

class EventDetailsController: UIViewController {
    
    var eventsCollectionViewController = EventsCollectionViewController()
    
    var event: Events? {
        didSet{
            navigationItem.title = event?.eventType
            titleLabel.text = event?.eventTitle
            descTextView.text = event?.eventDescription
            locationLabel.text = event?.eventLocation
            
            if let unixDate = event?.eventDate {
                guard let timeIntervalDate = TimeInterval(unixDate) else {return}
                let dateToBeFormattedForDisplay = Date(timeIntervalSince1970: timeIntervalDate)
                let formattedDate = DateFormatter.localizedString(from: dateToBeFormattedForDisplay, dateStyle: .full, timeStyle: .long)
                
                dateLabel.text = formattedDate
            }

            
            guard let eventImageName = event?.eventImageName else {return}
            eventImageView.loadEventImageUsingCacheWithUrlString(urlString: eventImageName)
        }
    }
    
    lazy var eventImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ringo")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomIn)))
        return image
    }()
    
    lazy var fbButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "facebook_button"), for: UIControlState.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleFBShare), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let descTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description"
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        return tv
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = String(describing: Date())
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addEventToCalendar)))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMap)))
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
    }
    
    func handleZoomIn() {
        
        let imageZoomedController = ImageZoomedController()
        imageZoomedController.event = event
        let navCon = UINavigationController(rootViewController: imageZoomedController)
        present(navCon, animated: true, completion: nil)
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        
        view.addSubview(eventImageView)
        view.addSubview(titleLabel)
        view.addSubview(descTextView)
        view.addSubview(dateLabel)
        view.addSubview(locationLabel)
        view.addSubview(fbButton)
        
        view.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: titleLabel)
        view.addConstraintsWithFormat(format: "H:|-75-[v0(226)]", views: eventImageView)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: descTextView)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: dateLabel)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: locationLabel)
        view.addConstraintsWithFormat(format: "H:|-50-[v0(50)]", views: fbButton)
        
        view.addConstraintsWithFormat(format: "V:|-55-[v0(40)]-4-[v1(300)]-10-[v2(100)]-4-[v3(40)]-4-[v4(40)]-4-[v5(50)]-10-|", views: titleLabel, eventImageView, descTextView, dateLabel, locationLabel, fbButton)
        
    }
    
    //creating an event function for the calendar with parameters Title, startDate and endDate must Import EventKit
    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date){
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: EKSpan.thisEvent)
        } catch {
            
            createAlert(title: "Event Cannot Be Saved!", message: "Please try again!")
        }
        
    }
    func addEventToCalendar(){
        
        guard let calendarDate = event?.eventDate else {return}
        
        guard let timeInterval = TimeInterval(calendarDate) else {return}
        let convertedDate = Date(timeIntervalSince1970: timeInterval)
        let startDate = convertedDate
        let endDate = startDate.addingTimeInterval(60 * 60) // + One hour
        let eventStore = EKEventStore()
        if (EKEventStore.authorizationStatus(for: EKEntityType.event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
                if error != nil {
                    self.createAlert(title: "Event Cannot Be Saved!", message: "Please try again!")
                } else {
                    if let eventTitle = self.event?.eventTitle {
                        self.createEvent(eventStore: eventStore, title: eventTitle, startDate: startDate, endDate: endDate)
                    }
                }
            })
        } else {
            if let eventTitle = event?.eventTitle {
                self.createEvent(eventStore: eventStore, title: eventTitle, startDate: startDate, endDate: endDate)
            }
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //Opening the address in maps.google by tapping on location //via SEARCH FUNC of maps.google
    func openMap() {
        let baseUrl : String = "http://maps.google.com/?q="
        let name = event?.eventLocation //detailLocation
        //replacing % to all unallowed characters like spaces
        let encodedName = name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = baseUrl + encodedName!
        let url = NSURL(string: finalUrl)!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
        
    }
    
    func handleFBShare() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.add(eventImageView.image)
            self.present(fbShare, animated: true, completion: nil)
        } else {
            createAlert(title: "Account", message: "Please login to FaceBook.")
        }
    }
}
