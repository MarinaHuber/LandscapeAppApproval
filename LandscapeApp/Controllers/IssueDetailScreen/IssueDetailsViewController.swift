//
//  IssueDetailsViewController.swift
//  LandscapeApp
//
//  Created by Max Park on 5/15/22.
//

import UIKit

class IssueDetailsViewController: UIViewController {
    
    // MARK: - Properties
    enum MenuState {
        case opened
        case closed
    }
    enum IssuePanelState {
        case opened
        case closed
    }
    private let menuVC = MenuViewController()
    private let mapVC = MapViewController()
    private let issuePanelVC = IssuePanelViewController()
    private var animator: DraggableTransitionDelegate?
    private var menuState: MenuState = .opened
    private var issuePanelState: IssuePanelState = .closed
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        addChildViewControllers()
        setupHideKeyboardOnTap()
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // MARK: - Private Methods
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Project Name"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "NavigationGray")
        navigationController?.navigationBar.isTranslucent = false
    }
    private func addChildViewControllers() {
        mapVC.delegate = self
        let navVC = UINavigationController(rootViewController: mapVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        mapVC.didMove(toParent: self)
        
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.view.frame = CGRect(
            x: 0,
            y: 74, // Temporary work around for status bar color
            width: 244,
            height: view.bounds.height - 74
        )
        menuVC.didMove(toParent: self)
        
        issuePanelVC.delegate = self
        addChild(issuePanelVC)
        view.addSubview(issuePanelVC.view)
        issuePanelVC.view.frame = CGRect(
            x: UIScreen.main.bounds.width,
            y: 74, // Temporary work around for status bar color
            width: 514,
            height: view.bounds.height - 74
        )
        issuePanelVC.didMove(toParent: self)
    }
}

// MARK: - Map View Controller Delegate
extension IssueDetailsViewController: MapViewControllerDelegate {
    func deselectAllPins(except pinIndex: Int) {
        menuVC.deselectAllPins(except: pinIndex)
    }
    
    func retreiveMarkers() -> [Marker] {
        self.menuVC.retrieveMarkers()
    }
    
    func didTapAnnotationButton() {
        switch issuePanelState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.issuePanelVC.view.frame.origin.x = UIScreen.main.bounds.width - 514
                self.menuVC.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.issuePanelState = .opened
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.issuePanelVC.view.frame.origin.x = UIScreen.main.bounds.width
                self.menuVC.view.frame.origin.x = -244
            } completion: { [weak self] done in
                if done {
                    self?.issuePanelState = .closed
                    self?.menuState = .closed
                }
            }
        }
    }
    
    func didTapMenuButton() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.menuVC.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done { self?.menuState = .opened }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.menuVC.view.frame.origin.x = -244
            } completion: { [weak self] done in
                if done { self?.menuState = .closed }
            }
        }
    }
}

// MARK: - Menu View Controller Delegate
extension IssueDetailsViewController: MenuViewControllerDelegate {
    func addMarkerToMap(marker: Marker) {
        mapVC.configureMarkers(marker: marker)
    }
    
    func configureIssuePanel(with pin: Pin, with issue: Issue) {
        issuePanelVC.configure(with: pin, with: issue)
    }
    
    func openIssuePanel() {
        switch issuePanelState {
        case .closed:
            //open
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.issuePanelVC.view.frame.origin.x = UIScreen.main.bounds.width - 514
                self.menuVC.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.issuePanelState = .opened
                    self?.menuState = .opened
                }
            }
        case .opened:
            //close
            return 
        }
    }
}

// MARK: - Issue Panel View Controller Delegate
extension IssueDetailsViewController: IssuePanelViewControllerDelegate {

    func didTapBackButtonIssue() {
        menuVC.selectPreviousIssue()
    }
    func didTapNextButtonIssue() {
        menuVC.selectNextIssue()
    }
    func didUpdateIssueTextField(name: String) {
        menuVC.updateIssueName(name: name)
    }
    func didAddNoteTextView(text: String, for type: IssueType) {
        menuVC.addNoteToIssue(text: text, for: type)
    }
    func didAddMediaToNote(images: [UIImage], for type: IssueType) {
        menuVC.addMediaToNote(images: images, for: type)
    }
    func fetchNotes() -> IssueNotes {
        menuVC.fetchNotes()
    }
    func didDeleteEntry(indexPath: IndexPath, for type: IssueType) {
        menuVC.deleteEntryFromNote(indexPath: indexPath, for: type)
    }
    func didDeleteNote(indexPath: IndexPath, for type: IssueType) {
        menuVC.deleteNoteFromIssue(indexPath: indexPath, for: type)
    }
    func replaceImage(with image: UIImage, photoIndex: IndexPath, noteIndex: IndexPath, for type: IssueType) {
        menuVC.replaceImage(with: image, photoIndex: photoIndex, noteIndex: noteIndex, for: type)
    }
    func didDeleteImageFromEntry(photoIndex: IndexPath, noteIndex: IndexPath, for type: IssueType) {
        menuVC.deleteImageFromEntry(photoIndex: photoIndex, noteIndex: noteIndex, for: type)
    }
    func didCopyEntry(indexPath: IndexPath, origin: IssueType, destination: IssueType) {
        menuVC.copyEntryToTab(indexPath: indexPath, origin: origin, destination: destination)
    }
    func didTapExportButtonIssue() {
        print("go to approve")
    }
}


