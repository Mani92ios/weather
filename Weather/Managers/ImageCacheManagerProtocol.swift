//
//  ImageCacheManagerProtocol.swift
//  Weather
//
//  Created by Mani on 13/09/24.
//

import UIKit

// Interface for handling the image cache
protocol ImageCacheManagerProtocol {
    // Get the cached image based on name
    func getCachedImage(for iconName: String) -> UIImage?
    // Cache the image with name
    func cacheImage(_ image: UIImage, for iconName: String)
}
