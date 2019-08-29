//
//  PhotoController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 29/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PhotoController: BaseListController {
    
    var dismissHandler: (() -> ())?
    
    let cellId = "cellId"
    
    var personImages: ImageStruct!
    var closeButtonTop : NSLayoutConstraint?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss() {
        print("Dismiss")
        dismiss(animated: true)
        closeButton.isHidden = true
        dismissHandler?()
    }
    
    init(personImages: ImageStruct, index: Int) {
        self.personImages = personImages
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCloseButton()
        collectionView.isScrollEnabled = false
        
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        collectionView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 44, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
        
        cell.configureCell(personImage: personImages)
        return cell
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return .init(width: view.frame.width - 48, height: 74)
        return .init(width: view.frame.width, height: view.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
