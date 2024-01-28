//
//  CacheManager.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 28.01.24.
//

import Foundation
import UIKit

class CacheManager {
    
    static let instance = CacheManager()
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 50
        cache.totalCostLimit = 100 * 1024 * 1024
        return cache
    }()
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("added to cache")
    }
    
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
        print("removed from cache")
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}
