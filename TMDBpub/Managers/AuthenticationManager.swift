//
//  AuthenticationManager.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 19/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation
import KeychainSwift

class AuthenticationManager {
    
    private lazy var keychain = KeychainSwift()
    lazy var authManager = AuthenticationManager()
    
    lazy var apiKey: String = {
        let keys = retrieveKeys()
        return keys.apiKey
    }()
    
    // MARK: - Initializers
    
    init() {
//        setupStores()
    }
    
    // MARK: - Public
    
    func saveCurrentUser(_ sessionId: String, accountId: Int) {
        saveSessionId(sessionId)
        saveUserAccountId(accountId)
    }
    
    func deleteCurrentUser() {
        deleteSessionId()
        deleteAccessToken()
        deleteUserAccountId()
        
        print("sessionId:", Constants.sessionId)
        APIService.shared.deleteSessionId(sessionId: Constants.sessionId) { (success, error) in
            if success {
                print("Deleting sessionId is successful")
            } else {
                print("Deleting sessionId is unsuccessful", error!)
            }
        }
        print("Data in Keychain were deleted")
    }
    
    // MARK: - Session Id
    
    private func saveSessionId(_ sessionId: String) {
        keychain.set(sessionId, forKey: localConstants.sessionIdKey)
    }
    
    private func deleteSessionId() {
        keychain.delete(localConstants.sessionIdKey)
    }
    
    private func retrieveSessionId() -> String? {
        return keychain.get(localConstants.sessionIdKey)
    }
    
    // MARK: - Access Token
    
    func saveAccessToken(_ accessToken: AccessToken) {
        keychain.set(accessToken.sessionId, forKey: localConstants.sessionIdKey)
        keychain.set(accessToken.accountId, forKey: localConstants.accountIdKey)
    }
    
    private func deleteAccessToken() {
        keychain.delete(localConstants.accessTokenKey)
    }
    
    var accessToken: AccessToken? {
        guard let sessionId = retrieveSessionId(),
            let accountId = retrieveUserAccountId() else {
                return nil
        
//        guard let sessionId = keychain.get(localConstants.sessionIdKey),
//            let accountId = keychain.get(localConstants.accountIdKey) else {
//                return nil
        }
        return AccessToken(sessionId: sessionId, accountId: accountId)
    }
    
    // MARK: - Credentials
    
    var userCredentials: (sessionId: String, accountId: String)? {
        guard let sessionId = retrieveSessionId(),
            let accountId = retrieveUserAccountId() else {
                return nil
        }
        return (sessionId: sessionId, accountId: accountId)
    }
    
    // MARK: - User Account Id
    
    private func saveUserAccountId(_ userId: Int) {
        keychain.set(String(userId), forKey: localConstants.currentUserIdKey)
    }
    
    private func deleteUserAccountId() {
        keychain.delete(localConstants.currentUserIdKey)
    }
    
    private func retrieveUserAccountId() -> String? {
        guard let userAccountIdString = keychain.get(localConstants.currentUserIdKey) else {
            return nil
        }
//        return Int(userAccountIdString)
        return userAccountIdString
    }
    
    // MARK: - Authentitacion Persistence
    
    func isUserSignedIn() -> Bool {
//        return currentUser() != nil
        print("accessToken?.accountId:", String(accessToken?.accountId ?? ""))
        print("accessToken?.sessionId:", String(accessToken?.sessionId ?? ""))
        return (accessToken?.accountId != nil && accessToken?.sessionId != nil)
    }
    
//    func currentUser() -> User? {
//        guard let credentials = userCredentials else { return nil }
//        return userStore.find(with: credentials.accountId)
//    }
    
    // MARK: - TheMovieDb Keys
    
    private func retrieveKeys() -> Keys {
        guard let url = Bundle.main.url(forResource: "TMDBdb",
                                        withExtension: ".plist") else {
                                            fatalError()
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let plist = try decoder.decode([String: Keys].self, from: data)
            guard let keys = plist["Keys"] else { fatalError() }
            return keys
        } catch {
            fatalError()
        }
    }
    
}

extension AuthenticationManager {
    
    struct localConstants {
        static let accessTokenKey = "TMDBpubAccessToken"
        static let accountIdKey = "TMDBpubAccessAccountId"
        static let sessionIdKey = "TMDBpubSessionId"
        static let currentUserIdKey = "TMDBpubUserId"
    }
    
}

