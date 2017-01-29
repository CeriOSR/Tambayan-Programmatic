//
//  TabBarController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-26.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let eventsCategoryController = EventsCategoryCollectionController(collectionViewLayout: layout)
        let eventCategoriesController = UINavigationController(rootViewController: eventsCategoryController)
        eventsCategoryController.tabBarItem.title = "Categories"
        eventsCategoryController.tabBarItem.image = UIImage(named: "people")
        
        let addEventsController = AddEventsController()
        let addEventsNavController = UINavigationController(rootViewController: addEventsController)
        addEventsController.tabBarItem.title = "Add Event"
        addEventsController.tabBarItem.image = UIImage(named: "groups")
        
        
        viewControllers = [eventCategoriesController, addEventsNavController]
    }
    
    
}
