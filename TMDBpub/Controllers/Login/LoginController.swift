//
//  LoginController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 18/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    private lazy var authManager = AuthenticationManager()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        //        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "pattern")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleBack() {
        AppDelegate.shared.rootViewController.switchToMainScreen()
//        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        print("Handle login")
//            self.dismiss(animated: true, completion: {
                APIService.shared.authenticateWithViewController(hostViewController: self) { (success, errorString) in
                    if success {
                        print("Ok. About to show main tab bar")
                        LoaderController.shared.showLoader()
                        
                        APIService.shared.loadingUserDataFromNet(completion: {
                            APIService.shared.setFromAuthManagedData()
                            LoaderController.shared.removeLoader()
                            AppDelegate.shared.rootViewController.switchToMainScreen()
                        })
                        
                    } else {
                        print("Error during authorization in handle login")
                    }
                }
//            })
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
//            emailTextField,
//            passwordTextField,
            loginButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
//        setBackgroundImage()
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
//        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
//        view.addSubview(backToRegisterButton)
//        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.1098039216, green: 0.5725490196, blue: 0.8509803922, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.2304878831, green: 0.3483577371, blue: 0.5966511965, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
}
