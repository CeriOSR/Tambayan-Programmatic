//
//  Extensions.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-29.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadEventImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            
            self.image = cacheImage
            return
            
        } else {
            let url = NSURL(string: urlString)
            URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    
                    let err = error as! NSError
                    print(err)
                    return
                    
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                    
                }
            }).resume()
            
        }
        
    }

}

//shorten the constraints, COPY AND PASTE THIS WHEN USING addConstraints withVisualFormat
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        //making the views dictionary
        var viewsDictionary = [String: UIView]()
        //loop through the views and assign a index to the views then stick that index to the string as the viewID
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        //adding the parameters into the addConstraints() method
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}

