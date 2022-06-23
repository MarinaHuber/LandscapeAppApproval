//
//  CustomImageView.swift
//  LandscapeApp
//
//  Created by Max Park on 6/12/22.
//

import UIKit

class CustomImageView: UIImageView {
    init(image: UIImage?, contentMode: UIView.ContentMode) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Map
class CustomMapImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(frame: .zero)
        self.image = image
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


