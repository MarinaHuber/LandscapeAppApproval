//
//  IssueTableViewCell.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "IssueTableViewCell"
    
    // MARK: - UI Components
    private let cellView: UIView = CustomView(color: .clear, cornerRadius: 0)
    private let statusView: UIImageView = CustomImageView(image: UIImage(systemName: "checkmark"), contentMode: .scaleAspectFill)
    private let issueLabel: UILabel = CustomLabel()
    private let approvalView: UIImageView = CustomImageView(image: UIImage(systemName: "captions.bubble.fill"), contentMode: .scaleAspectFill)
    
    // MARK: - Object Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Color.SelectedCellColor
        
        contentView.addSubview(cellView)
        cellView.addSubview(statusView)
        cellView.addSubview(issueLabel)
        cellView.addSubview(approvalView)
        
        let view = UIView()
        view.backgroundColor = .clear
        
        let selectedView = UIView()
        selectedView.frame = CGRect(x: 8, y: 4, width: 244 - 44 - 16, height: 44 - 8)
        selectedView.layer.cornerRadius = 8
        selectedView.backgroundColor = .white
        selectedView.alpha = 0.5
        
        view.addSubview(selectedView)
        selectedBackgroundView = view
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            statusView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 18),
            statusView.widthAnchor.constraint(equalToConstant: 14),
        ])
        NSLayoutConstraint.activate([
            issueLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            issueLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 9),
            issueLabel.widthAnchor.constraint(equalToConstant: 110),
        ])
        NSLayoutConstraint.activate([
            approvalView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            approvalView.leadingAnchor.constraint(equalTo: issueLabel.trailingAnchor, constant: 9),
        ])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedBackgroundView?.isHidden = false
        } else {
            selectedBackgroundView?.isHidden = true
        }
    }
    
    // MARK: - Public Methods
    public func configure(with model: Issue) {
        issueLabel.text = model.name
    }
}
