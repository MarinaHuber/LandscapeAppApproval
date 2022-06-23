//
//  CustomButton.swift
//  LandscapeApp
//
//  Created by Max Park on 6/12/22.
//

import UIKit

// MARK: - Custom Button
class CustomButton: UIButton {
    init(title: String, titleColor: UIColor?, font: UIFont?) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Image Button
class CustomImageButton: UIButton {
    init(image: UIImage?, contentMode: UIButton.ContentMode) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.imageView?.contentMode = contentMode
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



