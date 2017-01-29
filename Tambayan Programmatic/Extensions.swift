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
