//
//  ParserHelper.swift
//  XRentY
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

protocol Parceable {
    static func parseObject(dictionary: [String: AnyObject]) -> Self?
}

class ParserHelper {
    
    static func parse<T: Parceable>(data: Data, completion : (Result<Response<T>, ErrorResult>) -> Void) {
        
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                let result = Response<T>.init().parse(json: result)
                switch result {
                case .failure(let error):
                    completion(Result.failure(error))
                case .success(let response):
                    completion(Result.success(response))
                }
            } else {
                // not a dictionary
                completion(.failure(.parser(string: "There was a problem retrieving data.\nPlease try again later.")))
            }
        } catch {
            print(T.self)
            // can't parse json
            completion(.failure(.parser(string: "There was a problem retrieving data.\nPlease try again later.")))
        }
    }
}
