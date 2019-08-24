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
    fileprivate func setup() {
        backgroundColor = UIColor.lightGray
    }
    
    func set(sideButtonsView view: RHSideButtons) {
        sideButtonsView = view
        print("Set to parent view")
    }
}
