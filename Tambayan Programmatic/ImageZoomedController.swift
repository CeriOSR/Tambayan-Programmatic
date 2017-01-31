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
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ringo")
        image.contentMode = .scaleAspectFill
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBack))

        view.addSubview(imageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

   
}
