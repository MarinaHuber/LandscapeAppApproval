//
//  Marker.swift
//  LandscapeApp
//
//  Created by Max Park on 6/19/22.
//

import UIKit

// MARK: - Custom Pin Marker
protocol MarkerDelegate: AnyObject {
    func updateMarkerPosition(x: CGFloat, y: CGFloat)
    func deselectAllPins(except pinIndex: Int)
}

class Marker: UIImageView {
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var isDragging: Bool = false
    weak var delegate: MarkerDelegate?
    let centerOffset: CGFloat = 20
    var isSelected: Bool = true {
        didSet {
            if isSelected {
                self.image = UIImage(named: "Pin")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
                delegate?.deselectAllPins(except: self.tag)
            } else {
                self.image = UIImage(named: "Pin")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    let pinLabel = UILabel()
    
    init(color: UIColor) {
        super.init(frame: .zero)
        configureButton(with: color)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureButton(with color: UIColor) {
        self.image = UIImage(named: "Pin")?.withTintColor(color, renderingMode: .alwaysOriginal)
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
    
    private func configureLabel() {
        self.addSubview(pinLabel)
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4),
            pinLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pinLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            pinLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        pinLabel.textAlignment = .center
        pinLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pinLabel.textColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        isDragging = true
        isSelected = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDragging, let touch = touches.first else { return }
        
        let location = touch.location(in: superview)
        self.center = CGPoint(x: location.x, y: location.y)
        delegate?.updateMarkerPosition(x: self.center.x, y: self.center.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
    }
}
