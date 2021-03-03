//
//  UIImageView+Extensions.swift
//  TaskList
//
//  Created by Admin on 2021/03/03.
//

import UIKit

var imageCache = [String: UIImage]()

extension UIImageView {
    
    func cacheImage(_ urlString: String) {
        self.image = nil
        
        // did check cache
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch image:", err)
                return
            }
            
            guard let imageData = data else { return }
            let image = UIImage(data: imageData)
            imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
