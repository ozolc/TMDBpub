//
//  PersonImagesListController.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 28/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class PersonImagesListController: BaseListController {
    
    let singleImageCellId = "singleImageCellId"
    
    var personImages: [ImageStruct]?
//    {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    init(personImages: [ImageStruct]) {
        self.personImages = personImages
        super.init()
    }
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    var appFullscreenController: PhotoController!
    
    var anchoredConstraints: AnchoredConstraints?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        collectionView.register(SingleImageCell.self, forCellWithReuseIdentifier: singleImageCellId)
        
        collectionView.backgroundColor = .white
    }
    
    var startingFrame: CGRect?
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    @objc func handleAppFullscreenDismissal
        () {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            self.appFullscreenController.collectionView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            self.navigationController?.navigationBar.transform = .identity
            
            guard let cell = self.appFullscreenController.collectionView.cellForItem(at: [0, 0]) as? PhotoCell else { return }
//                        cell.closeButton.alpha = 0
            self.appFullscreenController.closeButton.alpha = 0
//            self.appFullscreenController.closeButtonTop?.constant = 84
//            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
        
        setupSingleAppFullscreenController(indexPath)
        setupAppFullScreenStartingPosition(indexPath)
        beginAnimationAppFullscreen()
        
    }
    
    fileprivate func setupAppFullScreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        // auto layout constraint animations
        // 4 anchors
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded()
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        guard let personImages = personImages else { return }
        let appFullscreenController = PhotoController(personImages: personImages[indexPath.item], index: indexPath.item)
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
    }
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.collectionView.contentOffset.y
        }
        
        if appFullscreenController.collectionView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                
                var scale = 1 - translationY / 1000
                
                print(trueOffset, scale)
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -100)
            
            guard let cell = self.collectionView.cellForItem(at: [0, 0]) as? PhotoCell else { return }
//            cell.topAnchor.constraint(equalTo: self.navigationController., constant: 48)
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        guard let personImages = personImages else { return }
        let fullController = PhotoController(personImages: personImages[indexPath.item], index: indexPath.item)
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            showSingleAppFullScreen(indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: singleImageCellId, for: indexPath) as! SingleImageCell
        
        if let personImage = personImages?[indexPath.item] {
            cell.configureCell(profile: personImage)
        }
        return cell
            
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4 * spacing) / 3
        return CGSize(width: width, height: width + 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PersonImagesListController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
