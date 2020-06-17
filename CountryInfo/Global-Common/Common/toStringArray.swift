//
//  toStringArray.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/13/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation

//function to return string arrays to add to values array
func toStringArray(_ value: Any) -> [String] {
    //set item to the type of the value
    let item = type(of: value)

    //if it is a String return array of one String
    if item == String.self {
        let valueString = value as! String
        if valueString == "" { return [] }
        return [valueString]
    }
    
    //if it is an Int return array of one String
    if item == Int.self {
        let valueInt = value as! Int
        return [String(valueInt)]
    }
    
    //if it is an Optional Double return array of one String
    if item == Optional<Double>.self {
        guard let valueDoub = value as? Double else { return [] }
        return [String(valueDoub)]
        
    }
    
    //if it is an array of String, return array of String
    if item == Array<String>.self {
        return value as! [String]
    }
    
    //if it is an array of Currency, return an array of Strings from currency name
    if item == Array<Currency>.self {
        var currencies = [String]()
        let valueArray = value as! [Currency]
        for currency in valueArray {
            guard let name = currency.name else { continue }
            currencies.append(name)
        }
        return currencies
    }
    
    //if it is an array of Language, return an array of Strings from language name
    if item == Array<Language>.self {
        var languages = [String]()
        let valueArray = value as! [Language]
        for language in valueArray {
            languages.append(language.name)
        }
        return languages
    }
    
    //if it isn't any of these types return an empty array
    return []
}
