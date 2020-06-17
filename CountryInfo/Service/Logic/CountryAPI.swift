//
//  CountryAPI.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/4/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation
import os.log

class CountryAPI {
    //get all countries from restcountries api
    func getCountries(handler: @escaping(([Country]?,APIError?) -> Void)) {
        API.shared.get(from: "https://restcountries.eu/rest/v2/all", handler: handler)
    }
}
