import UIKit
import Foundation


//
//  ImageCache.swift
//  OpenTweet
//
//  Created by Douglas Cobb on 4/26/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//


public class ImageCache {
    
    public static let publicCache = ImageCache()
    var placeholderImage = UIImage(systemName: "rectangle")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(UIImage?) -> Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    final func load(_ url: NSURL, completion: @escaping (UIImage?) -> Void) {
        
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        // In case there are more than one requestor for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        // Go fetch the image.
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            
            // Check for the error, then data and try to create the image.
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the image.
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            
            // Iterate over each requestor for the image and pass it back.
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
                return
            }
            
        }.resume()
    }
}
