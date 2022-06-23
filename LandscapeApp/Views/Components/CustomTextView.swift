//
//  CustomTextView.swift
//  LandscapeApp
//
//  Created by Max Park on 6/12/22.
//

import UIKit

class CustomTextView: UITextView {
    init() {
        super.init(frame: .zero, textContainer: nil)
        self.backgroundColor = UIColor(named: "IssueTextFieldGray")
        self.layer.cornerRadius = 4
        self.font = UIFont(name: "SFProText-Semibold", size: 17)
        self.textColor = UIColor.black
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
