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
    
    func fetchMoviesStat(typeOfRequest: String, page: Int = 1, completionHandler: @escaping ([Movie]) -> ()) {
        print("Getting popular movies...")
        
        let parameters = [
            "api_key": Constants.apiKey,
            "language": Constants.language,
            "page": page
            ] as [String : Any]
        
        let requestURL = Constants.baseURL + typeOfRequest
        AF.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.default).response { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact \(requestURL)", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(ResultsMovie.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
        
    }
}
