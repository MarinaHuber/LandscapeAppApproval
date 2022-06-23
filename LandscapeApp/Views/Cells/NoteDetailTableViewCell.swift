//
//  NoteDetailTableViewCell.swift
//  LandscapeApp
//
//  Created by Max Park on 5/26/22.
//

import UIKit

class NoteDetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "NoteDetailTableViewCell"
    
    // MARK: - UI Components
    private let cellView: UIView = CustomView(color: .white, cornerRadius: 4)
    private let dateLabel: UILabel = CustomDateLabel()
    private let detailLabel: UILabel = CustomLabel()
    
    // MARK: - Object Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "IssuePanelBackground")
        selectionStyle = .none
        
        contentView.addSubview(cellView)
        cellView.addSubview(dateLabel)
        cellView.addSubview(detailLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            cellView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
        ])
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            detailLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -16),
            detailLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            detailLabel.widthAnchor.constraint(equalTo: cellView.widthAnchor, constant: -32),
        ])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Methods
    public func configure(note: NoteType) {
        let date = note.date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        dateLabel.text = formatter.string(from: date)
        detailLabel.text = note.text
    }
    public func setHighlight(isHighlighted: Bool) {
        detailLabel.isHighlighted = isHighlighted
        detailLabel.highlightedTextColor = .systemBlue
    }
}
