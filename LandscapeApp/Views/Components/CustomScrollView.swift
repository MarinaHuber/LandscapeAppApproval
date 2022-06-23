//
//  CustomScrollView.swift
//  LandscapeApp
//
//  Created by Max Park on 6/12/22.
//

import UIKit

class CustomScrollView: UIScrollView {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "IssuePanelBackground")
//        self.alwaysBounceVertical = false
//        self.alwaysBounceHorizontal = false
//        self.showsVerticalScrollIndicator = false
//        self.showsHorizontalScrollIndicator = false
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 10.0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.canCancelContentTouches = false
        self.delaysContentTouches = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
