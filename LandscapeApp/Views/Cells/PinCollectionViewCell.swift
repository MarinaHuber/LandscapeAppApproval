//
//  PinCollectionViewCell.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import UIKit

class PinCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "PinCollectionViewCell"
    override var isSelected: Bool {
        didSet {
            if isSelected { // Selected cell
                self.backgroundColor = Color.SelectedCellColor
                self.pinView.image = UIImage(named: "Pin")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            } else { // Normal cell
                self.backgroundColor = UIColor(named: "NavigationGray")
                self.pinView.image = UIImage(named: "Pin")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
           }
        }
    }
    
    // MARK: - UI Components
    private let pinView: UIImageView = CustomImageView(image: nil, contentMode: .scaleAspectFit)
    var pinLabel = UILabel()
    
    // MARK: - Object Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isSelected = false
        configurePinView()
        configureLabel()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configurePinView() {
        let padding: CGFloat = 4
        addSubview(pinView)
        NSLayoutConstraint.activate([
            pinView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            pinView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            pinView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            pinView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
    private func configureLabel() {
        pinView.addSubview(pinLabel)
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinLabel.topAnchor.constraint(equalTo: pinView.topAnchor, constant: -4),
            pinLabel.leadingAnchor.constraint(equalTo: pinView.leadingAnchor),
            pinLabel.trailingAnchor.constraint(equalTo: pinView.trailingAnchor),
            pinLabel.bottomAnchor.constraint(equalTo: pinView.bottomAnchor),
        ])
        
        pinLabel.textAlignment = .center
        pinLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pinLabel.textColor = .white
    }
    
    // MARK: - Public Methods
    public func configure(with model: Pin) {
        let color = model.color
        let image = UIImage(named: "Pin")?.withTintColor(color, renderingMode: .alwaysOriginal)
        pinView.image = image
        pinLabel.text = model.marker.pinLabel.text
    }
}
