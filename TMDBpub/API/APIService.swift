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
    
    var authManager = AuthenticationManager()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    func fetchMoviesStat<T: Decodable>(typeOfRequest: String, query: String? = nil, page: Int? = nil, include_adult: Bool? = nil, with_genres: String? = nil, language: String? = nil, sessionId: String? = nil, accountList: String? = nil, completionHandler: @escaping (T) -> ()) {
        
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
        
        if sessionId != nil {
            parameters["session_id"] = sessionId
        }
        
        let requestURL = Constants.baseURL + typeOfRequest
        AF.request(requestURL, method: .get, parameters: parameters, encoding: URLEncoding.default).response { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact \(requestURL)", err)
                return
            }
            
//            print(dataResponse.request)
            
            guard let data = dataResponse.data else { return }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completionHandler(objects)
                
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    func taskForGETMethod<T: Decodable>(method: String, parameters: [String: Any], httpMethod: HTTPMethod, completionHandler: @escaping (_ result: T?, _ error: Error?) -> Void) {
        
        /* 2/3. Build the URL, Configure the request */
        let requestURL = Constants.baseURL + method
        
        AF.request(requestURL, method: httpMethod, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
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
    
    func taskForPOSTMethod<T: Decodable>(requestURL: String, parameters: [String: Any],  httpMethod: HTTPMethod, jsonBody: [String: Any], completionHandler: @escaping (_ result: T?, _ error: Error?) -> Void) {
        
        let headers = ["content-type": "application/json;charset=utf-8"]
        let postData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: URL(string: requestURL)!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print("error with response status: \(String(describing: error))")
                completionHandler(nil, error)
                return
            } else {
                print("Yeah! Hand response")
                do {
                    guard let data = data else { return }
                    let objects = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(objects, nil)
                } catch let err {
                    print("Failed to decode from JSON:", err)
                    completionHandler(nil, err)
                    return
                }
            }
        })
        dataTask.resume()   
    }
    

    func postToFavorites(mediaType: Constants.MediaType, mediaId: Int, isFavorite: Bool, typeOfParameter: Constants.ParameterKeysAccount, completionHandlerForFavorite: @escaping (_ result: ResponseResult?, _ error: Error?) -> Void)  {
        
        let parameters = [
            "media_type": mediaType.description,
            "media_id": mediaId,
            typeOfParameter.description: isFavorite
            ] as [String : Any]
        
        /* 2. Make the request */
        let typeOfRequest = Constants.baseURL +
            Constants.Account + "/" +
            Constants.accountId + "/" +
            typeOfParameter.description
            + "?api_key=" +
            Constants.apiKey + "&session_id=" + Constants.sessionId
        
        print(typeOfRequest)
        taskForPOSTMethod(requestURL: typeOfRequest, parameters: parameters, httpMethod: .post, jsonBody: parameters) { (results: ResponseResult?, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForFavorite(nil, error)
            } else {
                print(results?.statusCode ?? 0, results?.statusMessage ?? "statusMessage")
                completionHandlerForFavorite(results, nil)
            }
        }
    }
    
    func postRateMovie(mediaId: Int, rateValue: Int, completionHandlerForFavorite: @escaping (_ result: ResponseResult?, _ error: Error?) -> Void)  {
        
        let parameters = [
            "value": rateValue
            ] as [String : Any]
        
        /* 2. Make the request */
        let typeOfRequest = Constants.baseURL +
            Constants.movie + "/" +
            Constants.rating + "/" +
            "?api_key=" + Constants.apiKey +
            "&session_id=" + Constants.sessionId
        
        print(typeOfRequest)
        taskForPOSTMethod(requestURL: typeOfRequest, parameters: parameters, httpMethod: .post, jsonBody: parameters) { (results: ResponseResult?, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForFavorite(nil, error)
            } else {
                print(results?.statusCode ?? 0, results?.statusMessage ?? "statusMessage")
                completionHandlerForFavorite(results, nil)
                //
            }
        }
    }
    
    private func getRequestToken(completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        
        /* 1. Set the parameters */
        var parameters = [String: Any]()
        parameters[Constants.ParameterKeys.ApiKey] = Constants.apiKey
        
        /* 1. Make the request */
        taskForGETMethod(method: Constants.AuthenticationTokenNew, parameters: parameters, httpMethod: .get) { (results: RequestTokenResult?, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
            } else {
                if let requestToken = results?.token {
                    print("requestToken =", requestToken)
                    completionHandlerForToken(true, requestToken, nil)
                } else {
                    print("Could not find \(Constants.ParameterKeys.RequestToken)")
                    completionHandlerForToken(false, nil, "Login Failed (Request Token).")
                }
            }
        }
    }
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        getRequestToken() {[weak self] (success, requestToken, errorString) in
            
            if success {
                // success! we have the requestToken!
                APIService.shared.requestToken = requestToken
                
                print("success! we have the requestToken!")
                
                self?.loginWithToken(requestToken: requestToken, hostViewController: hostViewController) { (success, errorString) in
                    
                    if success {
                        print("success! we have the tokenID!")
                        self?.getSessionID(requestToken: requestToken) { (success, sessionID, errorString) in
                            
                            if success {
                                self?.sessionID = sessionID
                                
                                self?.getUserID() { (success, userID, errorString) in
                                    
                                    if success {
                                        
                                        if let userID = userID {
                                            print("success! we have the userID:", userID)
                                            self?.userID = userID
                                            
                                            guard let sessionID = sessionID else { return }
                                            self?.authManager.saveCurrentUser(sessionID, accountId: userID)
                                           Constants.sessionId = sessionID
                                        }
                                    }
                                    
                                    completionHandlerForAuth(success, errorString)
                                }
                            } else {
                                completionHandlerForAuth(success, errorString)
                            }
                        }
                    } else {
                        completionHandlerForAuth(success, errorString)
                    }
                }
            }
        }
    }
    
    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
    private func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        guard let authorizationURL = URL(string: "\(Constants.AuthorizationURL)\(requestToken!)") else { return }
        let request = URLRequest(url: authorizationURL)
        
        //            NSURLRequest(URL: authorizationURL!)
        let webAuthViewController = TMDBAuthViewController()
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
        
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    private func getSessionID(requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Set the parameters */
        
        guard let requestToken = requestToken else {
            print("requestToken is nil")
            return
        }
        
        print("Before requestion Session ID. requestToken =", requestToken)
        
        let parameters = [
            "api_key": Constants.apiKey,
            "request_token": requestToken
            ] as [String : Any]
        
        taskForGETMethod(method: Constants.AuthenticationSessionNew, parameters: parameters, httpMethod: .get) { (results: SessionResult?, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
            } else {
                if let sessionID = results?.sessionId {
                    completionHandlerForSession(true, sessionID, nil)
                } else {
                    print("Could not find \(Constants.ParameterKeys.SessionID)")
                    completionHandlerForSession(false, nil, "Login Failed (Session ID).")
                }
            }
        }
    }
    
    private func getUserID(completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        guard let sessionID = sessionID else {
            print("sessionID is nil")
            return
        }
        
        print("Before requestion Account ID. sessionID =", sessionID)
        
        let parameters = [
            "api_key": Constants.apiKey,
            "session_id": sessionID
            ] as [String : Any]
        
        /* 2. Make the request */
        taskForGETMethod(method: Constants.Account, parameters: parameters, httpMethod: .get) { (results: User?, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserID(false, nil, "Login Failed (User ID).")
            } else {
                if let userID = results?.id {
                    completionHandlerForUserID(true, userID, nil)
                } else {
                    print("Could not find \(Constants.UserID)")
                    completionHandlerForUserID(false, nil, "Login Failed (User ID).")
                }
            }
        }
    }
    
    
    func deleteSessionId(sessionId: String?, completionHandlerForDeletingSessionID: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Set the parameters */
        guard let sessionId = sessionId else {
            print("Cannot get sessionId from userCredentials ")
            return }
        let parameters = [
            "api_key": Constants.apiKey,
            "session_id": sessionId
            ] as [String : Any]
        
        /* 1. Make the request */
        taskForGETMethod(method: Constants.DeletingSessionId, parameters: parameters, httpMethod: .delete) { (results: SessionDelete?, error) in
            
            /* 2. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForDeletingSessionID(false, "Deleting Failed (Session ID).")
            } else {
                if let _ = results?.success {
                    print("sessionID = \(sessionId) was deleted." )
                    completionHandlerForDeletingSessionID(true, nil)
                } else {
                    print("Could not find \(Constants.ParameterKeys.SessionID)")
                    completionHandlerForDeletingSessionID(false, "Deleting Failed (Session ID).")
                }
            }
        }
    }
    
    func loadingUserDataFromNet(completion: @escaping () -> ()) {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        APIService.shared.fetchMoviesStat(typeOfRequest: Constants.Account, sessionId:  Constants.sessionId, completionHandler: { (user: User) in
            dispatchGroup.leave()
            globalUser = user
        })
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func loadingGenresFromNet(completion: @escaping () -> ()) {
        let infoAboutGenre = Constants.infoAboutGenre
        
        APIService.shared.fetchMoviesStat(typeOfRequest: infoAboutGenre, language: Constants.language, completionHandler: { (genre: Genre) in
            genresArray += genre.genres
            
        })
//        print("Genres successfully downloaded genres from net")
        completion()
    }
    
    func setGlobalUserFromKeychain() {
        Constants.apiKey = authManager.apiKey
        Constants.sessionId = authManager.userCredentials?.sessionId ?? "nil"
        Constants.accountId = authManager.userCredentials?.accountId ?? "nil"
        
        print("Session ID =", Constants.sessionId)
//        print("API Key =", Constants.apiKey)
//        print("Account ID =", Constants.accountId)
//        print("User is signed - ", self.authManager.isUserSignedIn())
    }
    
}
