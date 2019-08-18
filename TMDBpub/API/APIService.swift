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
    
    func fetchMoviesStat<T: Decodable>(typeOfRequest: String, query: String? = nil, page: Int? = nil, include_adult: Bool? = nil, with_genres: String? = nil, language: String? = nil, completionHandler: @escaping (T) -> ()) {
        
        var parameters = [
            "api_key": Constants.apiKey
            ] as [String : Any]
        
        if page != nil {
            parameters["page"] = page
        }
        
        if include_adult != nil {
            parameters["include_adult"] = true
        }
        
        if with_genres != nil {
            parameters["with_genres"] = with_genres
        }
        
        if query != nil {
            parameters["query"] = query
        }
        
        if language != nil {
            parameters["language"] = language
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
    
    // MARK: GET
    //    , completionHandler: @escaping (T) -> ()
    
    func taskForGETMethod<T: Decodable>(method: String, completionHandler: @escaping (_ result: T?, _ error: Error?) -> Void) {
        //        ((_ success: Bool, _ result: [String]?) -> Void)?) {
        //        (AnyObject?, NSError?) -> Void) {
        
        /* 1. Set the parameters */
        let parameters = [
            "api_key": Constants.apiKey
            ] as [String : Any]
        
        /* 2/3. Build the URL, Configure the request */
        let requestURL = Constants.baseURL + method
        
        AF.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            let message: String
            
            switch(response.result) {
            case .success:
                print("Yeah! Hand response")
                do {
                    guard let data = response.data else { return }
                    let objects = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(objects, nil)
                } catch let err {
                    print("Failed to decode from JSON:", err)
                    completionHandler(nil, err)
                    return
                }
                
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 200..<300:
                        message = "Your request returned a status code other than 2xx!"
                    case 400:
                        message = "Username or password not provided."
                    case 401:
                        message = "Incorrect password for user."
                    default:
                        message = "Undefined error."
                    }
                }
                
            case .failure(let error):
                message = error.localizedDescription
                print("error with response status: \(message)")
                completionHandler(nil, error)
                return
            }
        }
    }
 
    private func getRequestToken(completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        
        /* 1. Make the request */
        taskForGETMethod(method: Constants.AuthenticationTokenNew) { (results: RequestTokenResult?, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
            } else {
                if let requestToken = results?.token {
                    completionHandlerForToken(true, requestToken, nil)
                } else {
                    print("Could not find \(Constants.ParameterKeys.RequestToken)")
                    completionHandlerForToken(false, nil, "Login Failed (Request Token).")
                }
            }
        }
    }
    
    func authenticateWithViewController(completionHandlerForAuth: (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                // success! we have the requestToken!
                print("success! we have the requestToken!")
            
                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                    
                    if success {
                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
                            
                            if success {
                                
                                // success! we have the sessionID!
                                self.sessionID = sessionID
                                
                                self.getUserID() { (success, userID, errorString) in
                                    
                                    if success {
                                        
                                        if let userID = userID {
                                            
                                            // and the userID 😄!
                                            self.userID = userID
                                        }
                                    }
                                    
                                    completionHandlerForAuth(success: success, errorString: errorString)
                                }
                            } else {
                                completionHandlerForAuth(success: success, errorString: errorString)
                            }
                        }
                    } else {
                        completionHandlerForAuth(success: success, errorString: errorString)
                    }
                }
                
            }
        }
    }
    
}
