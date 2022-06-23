//
//  CustomLabel.swift
//  LandscapeApp
//
//  Created by Max Park on 6/12/22.
//

import UIKit

// MARK: - Custom Label
class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
        textColor = .black
        font = UIFont.systemFont(ofSize: 15)
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Date Label
class CustomDateLabel: CustomLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .gray
        textAlignment = .right
        font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Media Label
class CustomMediaLabel: CustomLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .gray
        font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
