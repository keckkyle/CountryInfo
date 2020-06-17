//
//  UserDefaultsAccess.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/12/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation

class UserDefaultsAccess {
    
    let defaults = UserDefaults.standard
    let key = "CountryList"
    
    static let shared = UserDefaultsAccess()
    
    private init(){}
    
    func getCountryList() -> [Country]? {
        
        if let codedCountryList = defaults.value(forKey: key) {
         
            let countryList = try? PropertyListDecoder().decode(Array<Country>.self, from: codedCountryList as! Data)
            
            return countryList
            
        } else {
            
            return nil
        }
        
    }
    
    func setCountryList(for countries: [Country]) -> Bool {
        do{
            
            try defaults.set(PropertyListEncoder().encode(countries), forKey: key)
            
            return true
            
        } catch {
            return false
        }
    }
    
}
