//
//  APIError.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/5/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation

enum APIError: Error {
    case serverError
    case internalError
    case parsingError
}
