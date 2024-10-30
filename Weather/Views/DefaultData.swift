//
//  DefaultData.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import Foundation
import UIKit

// Used as a model to store the details into user defaults.
struct DefaultData: Codable {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    let iconImageData: Data?
}
