//
//  NoteTableViewCell.swift
//  LandscapeApp
//
//  Created by Max Park on 5/26/22.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "NoteTableViewCell"
    
    // MARK: - UI Components
    private let cellView: UIView = CustomView(color: UIColor(named: "IssuePanelBackground"), cornerRadius: 0)
    private let dateLabel: UILabel = CustomLabel()
    private let accessoryTypeView: UIImageView = CustomImageView(image: nil, contentMode: .scaleAspectFit)
    
    // MARK: - Object Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "NavigationGray")
        contentView.addSubview(cellView)
        cellView.addSubview(dateLabel)
        cellView.addSubview(accessoryTypeView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cellView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
        ])
        NSLayoutConstraint.activate([
            accessoryTypeView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            accessoryTypeView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
        ])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Methods
    public func configure(note: Note) {
        let date = note.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let text = formatter.string(from: date)
        
        let boldText = text.components(separatedBy: ",")[0]
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        var normalText = text.components(separatedBy: ",")[1]
        normalText = "," + normalText
        let attr = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        let normalString = NSMutableAttributedString(string: normalText, attributes: attr)

        attributedString.append(normalString)
        dateLabel.attributedText = attributedString
    }
    
    public func setAccessoryType(with isOpen: Bool) {
        if isOpen {
            let image = UIImage(systemName: "chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            accessoryTypeView.image = image
        } else {
            let image = UIImage(systemName: "chevron.right")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            accessoryTypeView.image = image
        }
    }
    
}
