//
//  CountryAPIResponse.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/4/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation

struct Country: Codable {
    var flagImage: Data?
    var name: String
    var nativeName: String
    var alpha3Code: String
    var alpha2Code: String
    var capital: String
    var population: Int
    var area: Double?
    var demonym: String
    var languages: [Language]
    var timezones: [String]
    var currencies: [Currency]
    var region: String
    var subregion: String
    var borders: [String]
    var flagIcon: Data?
}

struct Currency: Codable {
    var code: String?
    var name: String?
    var symbol: String?
}

struct Language: Codable {
    var name: String
    var nativeName: String
}
