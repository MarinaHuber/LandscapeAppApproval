//
//  EntryMediaTableViewCell.swift
//  LandscapeApp
//
//  Created by Max Park on 5/31/22.
//

import UIKit

class EntryMediaCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier = "EntryMediaCollectionViewCell"
    
    // MARK: - UI Components
    private let mediaView: UIImageView = {
        let imageView = CustomImageView(image: UIImage(systemName: "photo"), contentMode: .scaleAspectFill)
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    // MARK: - Object Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mediaView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mediaView.frame = CGRect(
            x: 0,
            y: 0,
            width: 104,
            height: 78
        )
    }
    
    // MARK: - Public Methods
    public func configure(image: UIImage) {
        mediaView.image = UIImage(systemName: "photo")
        mediaView.image = image
    }
}
