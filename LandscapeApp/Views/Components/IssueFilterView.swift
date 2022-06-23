//
//  IssueFilterView.swift
//  LandscapeApp
//
//  Created by Max Park on 6/20/22.
//

import UIKit

class IssueFilterButton: UIButton {
    
    let issueFilter = IssueFilterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenu()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupMenu() {
        let allIssues = UIAction(title: "All Issues") { action in
        }
        let openIssues = UIAction(title: "Open Issues") { action in
        }
        let closedIssues = UIAction(title: "Closed Issues") { action in
        }
        let pendingApproval = UIAction(title: "Pending Approval") { action in
        }
        let menu = UIMenu(title: "", children: [allIssues, openIssues, closedIssues, pendingApproval])
        self.menu = menu
        self.showsMenuAsPrimaryAction = true
        self.addSubview(issueFilter)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            issueFilter.topAnchor.constraint(equalTo: topAnchor),
            issueFilter.leadingAnchor.constraint(equalTo: leadingAnchor),
            issueFilter.trailingAnchor.constraint(equalTo: trailingAnchor),
            issueFilter.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

class IssueFilterView: UIView {
    
    private let filterImageView = CustomImageView(image: SFSymbol.filter, contentMode: .scaleAspectFit)
    private let filterTypeLabel = UILabel()
    private let accessoryView = CustomImageView(image: SFSymbol.downArrow, contentMode: .scaleAspectFit)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = Color.NavigationGray
        translatesAutoresizingMaskIntoConstraints = false
        filterTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        filterTypeLabel.text = "All Issues"
        
        addSubview(filterImageView)
        addSubview(filterTypeLabel)
        addSubview(accessoryView)
        
        NSLayoutConstraint.activate([
            filterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            filterImageView.widthAnchor.constraint(equalToConstant: 18),
            filterImageView.heightAnchor.constraint(equalToConstant: 18),
            
            filterTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterTypeLabel.leadingAnchor.constraint(equalTo: filterImageView.trailingAnchor, constant: 9),
            
            accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryView.leadingAnchor.constraint(equalTo: filterTypeLabel.trailingAnchor, constant: 12),
        ])
        
        
    }
}
