//
//  ImageZoomedController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-31.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class ImageZoomedController: UIViewController {
    
    let eventDetailsController = EventDetailsController()
    
    var event: Events? {
        didSet{
            navigationItem.title = event?.eventTitle
            guard let imageName = event?.eventImageName else {return}
            imageView.loadEventImageUsingCacheWithUrlString(urlString: imageName)
        }
    }
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ringo")
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

   
}
