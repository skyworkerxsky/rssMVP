//
//  Network.swift
//  rssMVP
//
//  Created by Алексей Макаров on 28.02.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

class Network {
    
    static func getImage(url: String, completion: @escaping (_ imageData: UIImage) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, let image = UIImage(data: data) else {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                return
            }
            
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }.resume()
        
    }
    
}

