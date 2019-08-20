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
    }
    
    // MARK: - Session Id
    
    private func saveSessionId(_ sessionId: String) {
        keychain.set(sessionId, forKey: Constants.sessionIdKey)
    }
    
    private func deleteSessionId() {
        keychain.delete(Constants.sessionIdKey)
    }
    
    private func retrieveSessionId() -> String? {
        return keychain.get(Constants.sessionIdKey)
    }
    
    // MARK: - Access Token
    
    func saveAccessToken(_ accessToken: AccessToken) {
        keychain.set(accessToken.token, forKey: Constants.accessTokenKey)
        keychain.set(accessToken.accountId, forKey: Constants.accountIdKey)
    }
    
    private func deleteAccessToken() {
        keychain.delete(Constants.accessTokenKey)
    }
    
    var accessToken: AccessToken? {
        guard let token = keychain.get(Constants.accessTokenKey),
            let accountId = keychain.get(Constants.accountIdKey) else {
                return nil
        }
        return AccessToken(token: token, accountId: accountId)
    }
    
    // MARK: - User Account Id
    
    private func saveUserAccountId(_ userId: Int) {
        keychain.set(String(userId), forKey: Constants.currentUserIdKey)
    }
    
    private func deleteUserAccountId() {
        keychain.delete(Constants.currentUserIdKey)
    }
    
    private func retrieveUserAccountId() -> Int? {
        guard let userAccountIdString = keychain.get(Constants.currentUserIdKey) else {
            return nil
        }
        return Int(userAccountIdString)
    }
    
    // MARK: - Credentials
    
    var userCredentials: (sessionId: String, accountId: Int)? {
        guard let sessionId = retrieveSessionId(),
            let accountId = retrieveUserAccountId() else {
                return nil
        }
        return (sessionId: sessionId, accountId: accountId)
    }
    
    // MARK: - Authentitacion Persistence
    
    func isUserSignedIn() -> Bool {
//        return currentUser() != nil
        return accessToken?.accountId != nil
    }
    
//    func currentUser() -> User? {
//        guard let credentials = userCredentials else { return nil }
//        return userStore.find(with: credentials.accountId)
//    }
    
}

extension AuthenticationManager {
    
    struct Constants {
        static let accessTokenKey = "TMDBpubAccessToken"
        static let accountIdKey = "TMDBpubAccessAccountId"
        static let sessionIdKey = "TMDBpubSessionId"
        static let currentUserIdKey = "TMDBpubUserId"
//        accessTokenKey
    }
    
}

