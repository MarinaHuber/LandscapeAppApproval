//
//  ViewController.swift
//  LandscapeApp
//
//  Created by Max Park on 5/15/22.
//

import UIKit

class ProjectListViewController: UIViewController {
    
    // MARK: - UI Components
    private let projectButton: UIButton = CustomButton(title: "Project Name", titleColor: .systemBlue, font: .systemFont(ofSize: 40))
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(projectButton)
        projectButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        addContraints()
    }
    
    // MARK: - Selectors
    @objc private func tappedButton() {
        let vc = IssueDetailsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // MARK: - Private Methods
    private func addContraints() {
        NSLayoutConstraint.activate([
            projectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            projectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            projectButton.topAnchor.constraint(equalTo: view.topAnchor),
            projectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

