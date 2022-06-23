//
//  CustomView.swift
//  LandscapeApp
//
//  Created by Max Park on 6/12/22.
//

import UIKit

class CustomView: UIView {
    init(color: UIColor?, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
