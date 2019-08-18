//
//  LoginViewModel.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true
        
        print("Auth")
        APIService.shared.authenticateWithViewController { (success, err) in
            if success {
                print("Auth without errors")
            } else {
                print("Error:", err)
            }
        }
//        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
//            completion(err)
//        }
    }
}
