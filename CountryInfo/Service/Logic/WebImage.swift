//
//  WebImage.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/5/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation

class WebImage {
    //get image data from provided url string
    func getImageData(from url: String, handler: @escaping((Data?,APIError?) -> Void)) {
        API.shared.get(from: url, handler: handler)
    }
}
