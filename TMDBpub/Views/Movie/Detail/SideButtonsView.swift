//
//  SideButtonsView.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 24/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SideButtonsView: UIView {
    
    fileprivate let triggerButtonMargin = CGFloat(85)
    
    var sideButtonsView: RHSideButtons?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Layout Buttons
//        sideButtonsView?.setTriggerButtonPosition(CGPoint(x: bounds.width - triggerButtonMargin, y: bounds.height - triggerButtonMargin))
//    }
    
    fileprivate func setup() {
        backgroundColor = .lightGray
    }
    
    func set(sideButtonsView view: RHSideButtons) {
        sideButtonsView = view
        print("Set to parent view")
    }
}
