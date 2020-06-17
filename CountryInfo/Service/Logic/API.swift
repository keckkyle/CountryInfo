//
//  API.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/5/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import Foundation
import os.log

class API {
    //create instance of API class
    static var shared = API()
    //private init to create singleton class
    private init(){}
    //API get call using generic type
    func get<T: Codable>(from urlString: String, handler: @escaping (T?, APIError?) -> Void ){
        //create url String
        if let url = URL(string: urlString) {
            //create url session from url
            URLSession.shared.dataTask(with: url) { data, response, error in

                //check for errors
                if let error = error {
                    os_log("Error: %@", log: .default, type: .error, error.localizedDescription)
                    //return no data and error type
                    handler(nil, .serverError)
                    return
                }

                //check response is valid
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    os_log("Server error: %@", log: .default, type: .error, String(httpResponse.statusCode))
                    //return no data and error type
                    handler(nil, .serverError)
                    return
                }
                
                //check that data is valid
                if let data = data {
                    //if generic type is data type return data
                    if type(of: T.self) == Data.Type.self {
                        handler(data as? T, nil)
                        return
                    }
                    
                    do {
                        //decode data to correct type
                        let object = try JSONDecoder().decode(T.self, from: data)
                        //return object and no error
                        handler(object, nil)
                    } catch {
                        //if data cannot be decoded return no data and error
                        handler(nil, .parsingError)
                    }
                }
            }.resume()
        } else {
            //return no data and error if URL is invalid
            handler(nil, .internalError)
        }
    }
}
