//
//  CountryService.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/6/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation
import os.log

class CountryService {
    
    //created instance of CountryService to be used throughout application
    static let shared = CountryService()
    //set delegate
    var delegate: CountryListProtocol!
    //set countries list
    var countries = [Country]()
    //create instances of api services
    private let capi = CountryAPI()
    private let wi = WebImage()
    
    //set private init function to create singleton class
    private init(){
        if let countryList = UserDefaultsAccess.shared.getCountryList() {
            print("User Defaults Country list")
            self.countries = countryList
//            for country in countries {
//                print(country.name)
//            }
//            self.delegate.countryListUpdate()
        } else {
            print("Get Country list from API")
            self.setCountries()
        }
    }
    
    //function to call api and populate country list
    private func setCountries(){
        capi.getCountries { result, error in
            //check that there was no error making api call
            guard error == nil else {
                os_log("Unable to get countries list")
                return
            }
            
            if let countryList = result{
                //set country list
                self.countries = countryList
                //get images from apis
                self.setImageData()
            }
        }
    }

    private func setImageData() {
        //loop through countries list
        for i in 0..<self.countries.count {
            let code = countries[i].alpha2Code.lowercased()
            //set two urls for the different images
            let iconURL = "https://www.countryflags.io/\(code)/shiny/64.png"
            let imageURL = "https://flagpedia.net/data/flags/normal/\(code).png"
            //call api using imageURL to get large image
            wi.getImageData(from: imageURL) { result, error in
                //check that there was no error making api call
                guard error == nil else {
                    os_log("Unable to get image data")
                    return
                }
                DispatchQueue.main.async {
                    if let imageData = result {
                        //set flag image for current country in loop
                        self.countries[i].flagImage = imageData
                    }
                }
            }
            //call api using iconURL to get icon image
            wi.getImageData(from: iconURL) { result, error in
                //check that there was no error making api call
                guard error == nil else {
                    os_log("Unable to get icon data")
                    return
                }
                DispatchQueue.main.async {
                    if let imageData = result {
                        //set flag icon for current country in loop
                        self.countries[i].flagIcon = imageData
                        //call delegate function
                        self.delegate.countryListUpdate()
                    }
                }
            }
        }
    }
}
