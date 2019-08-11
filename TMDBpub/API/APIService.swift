//
//  APIService.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    // singleton
    static let shared = APIService()
    
    func fetchMoviesStat<T: Decodable>(typeOfRequest: String, page: Int? = nil, completionHandler: @escaping (T) -> ()) {
        
        var parameters = [
            "api_key": Constants.apiKey,
            "language": Constants.language,
//            "page": page ?? 1
            ] as [String : Any]
        
        if page != nil {
            parameters["page"] = page ?? 1
        }
        
        let requestURL = Constants.baseURL + typeOfRequest
        AF.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.default).response { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact \(requestURL)", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completionHandler(objects)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
}
