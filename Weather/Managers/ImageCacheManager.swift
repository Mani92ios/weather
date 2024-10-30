//
//  ImageCacheManager.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import UIKit

class ImageCacheManager: ImageCacheManagerProtocol {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        //Initialize the cache directory
        if let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.cacheDirectory = cacheDir
        } else {
            fatalError("Unable to locate cache directory")
        }
    }
    
    //Get the cached image from the cache based on the icon name
    func getCachedImage(for iconName: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent("\(iconName).png")
        // If file exists, return the image, else returns nil
        if fileManager.fileExists(atPath: fileURL.path),
           let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    //Cache the image based on the icon name.
    func cacheImage(_ image: UIImage, for iconName: String) {
        let fileURL = cacheDirectory.appendingPathComponent("\(iconName).png")
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}
