//
//  IssuePanelViewController.swift
//  LandscapeApp
// 
//  Created by Max Park on 5/16/22.
//

import UIKit
import Photos
import PhotosUI

// MARK: - Protocols
protocol IssuePanelViewControllerDelegate: AnyObject {
    func didTapBackButtonIssue()
    func didTapNextButtonIssue()
    func didUpdateIssueTextField(name: String)
    func didAddNoteTextView(text: String, for type: IssueType)
    func didAddMediaToNote(images: [UIImage], for type: IssueType)
    func didDeleteEntry(indexPath: IndexPath, for type: IssueType)
    func didDeleteNote(indexPath: IndexPath, for type: IssueType)
    func fetchNotes() -> IssueNotes
    func replaceImage(with image: UIImage, photoIndex: IndexPath, noteIndex: IndexPath, for type: IssueType)
    func didDeleteImageFromEntry(photoIndex: IndexPath, noteIndex: IndexPath, for type: IssueType)
    func didCopyEntry(indexPath: IndexPath, origin: IssueType, destination: IssueType)
    func didTapExportButtonIssue()
}

class IssuePanelViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: IssuePanelViewControllerDelegate?
    private var selectedNoteIndex = IndexPath()
    private var issueNotes = IssueNotes(reports: [], needApproval: [], inspirationBoard: [])
    private var textViewHeightConstraint: NSLayoutConstraint!
    private var heightForTextView: CGFloat = 0
    private var controlBarHeightConstraint: NSLayoutConstraint!
    private var heightForControlBar: CGFloat = 0
    private var isEditingEntry: Bool = false
    private var issueType: IssueType = .reports
    
    // MARK: - UI Components
    private var toolbarView: UIView = CustomView(color: UIColor(named: "NavigationGray"), cornerRadius: 0)
    private let backButton: UIButton = CustomImageButton(image: UIImage(systemName: "chevron.left"), contentMode: .scaleAspectFill)
    private let nextButton: UIButton = CustomImageButton(image: UIImage(systemName: "chevron.right"), contentMode: .scaleAspectFill)
    private let pinView: UIImageView = CustomImageView(image: nil, contentMode: .scaleAspectFit)
    private var pinLabel = UILabel()
    private var issueTextField: UITextField = CustomTextField()
    private let approvalView: UIImageView = CustomImageView(image: UIImage(systemName: "captions.bubble.fill"), contentMode: .scaleAspectFill)
    private let exportButton: UIButton = CustomImageButton(image: UIImage(systemName: "arrowshape.turn.up.right.fill"), contentMode: .scaleAspectFill)
    private var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [ "Reports", "Need Approval", "Inspiration Board"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    private var noteTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.register(NoteDetailTableViewCell.self, forCellReuseIdentifier: NoteDetailTableViewCell.identifier)
        tableView.register(NoteMediaTableViewCell.self, forCellReuseIdentifier: NoteMediaTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "IssuePanelBackground")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var noteControlBar: UIView = CustomView(color: UIColor(named: "NavigationGray"), cornerRadius: 4)
    private var addMediaButton: UIButton = CustomImageButton(image: UIImage(systemName: "plus"), contentMode: .scaleAspectFill)
    private var addImageButton: UIButton = CustomImageButton(image: UIImage(systemName: "camera.fill"), contentMode: .scaleAspectFill)
    private var noteTextView: UITextView = CustomTextView()
    private var submitTextButton: UIButton = CustomImageButton(image: UIImage(systemName: "arrow.up.circle.fill"), contentMode: .scaleAspectFill)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "IssuePanelBackground")
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        issueTextField.delegate = self
        
        noteTextView.delegate = self
        
        noteTableView.delegate = self
        noteTableView.dataSource = self
        
        noteTableView.estimatedRowHeight = 300
        noteTableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(toolbarView)
        toolbarView.addSubview(backButton)
        toolbarView.addSubview(nextButton)
        toolbarView.addSubview(pinView)
        pinView.addSubview(pinLabel)
        toolbarView.addSubview(issueTextField)
        toolbarView.addSubview(approvalView)
        toolbarView.addSubview(exportButton)
        view.addSubview(segmentedControl)
        view.addSubview(noteTableView)
        view.addSubview(noteControlBar)
        noteControlBar.addSubview(addMediaButton)
        noteControlBar.addSubview(addImageButton)
        noteControlBar.addSubview(noteTextView)
        noteControlBar.addSubview(submitTextButton)
        
        backButton.addTarget(self, action: #selector(didTapBackButton) , for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton) , for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        submitTextButton.addTarget(self, action: #selector(didTapSubmitTextButton), for: .touchUpInside)
        submitTextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSubmitTextButton)))
        submitTextButton.imageView?.tintColor = .gray
        exportButton.addTarget(self, action: #selector(didTapExportButton), for: .touchUpInside)
        
        textViewHeightConstraint = noteTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 132)
        textViewHeightConstraint.isActive = true
        textViewHeightConstraint.constant = 30
        noteTextView.layoutIfNeeded()
        
        controlBarHeightConstraint = noteControlBar.heightAnchor.constraint(lessThanOrEqualToConstant: 132)
        controlBarHeightConstraint.isActive = true
        controlBarHeightConstraint.constant = 30+16
        noteControlBar.layoutIfNeeded()
        
        issueNotes = (delegate?.fetchNotes())!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbarView.topAnchor.constraint(equalTo: view.topAnchor),
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.topAnchor.constraint(equalTo: toolbarView.topAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: toolbarView.leadingAnchor, constant: 17),
            backButton.widthAnchor.constraint(equalToConstant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 12),
       
            nextButton.topAnchor.constraint(equalTo: toolbarView.topAnchor, constant: 24),
            nextButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 21),
            nextButton.widthAnchor.constraint(equalToConstant: 10),
            nextButton.heightAnchor.constraint(equalToConstant: 12),
        
            pinView.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor, constant: 0),
            pinView.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 19),
            pinView.widthAnchor.constraint(equalToConstant: 28),
            pinView.heightAnchor.constraint(equalToConstant: 28),
            
            pinLabel.topAnchor.constraint(equalTo: pinView.topAnchor, constant: 0),
            pinLabel.leadingAnchor.constraint(equalTo: pinView.leadingAnchor, constant: 2),
            pinLabel.trailingAnchor.constraint(equalTo: pinView.trailingAnchor, constant: -2),
            pinLabel.bottomAnchor.constraint(equalTo: pinView.bottomAnchor, constant: -2),
        
            issueTextField.topAnchor.constraint(equalTo: toolbarView.topAnchor, constant: 16),
            issueTextField.leadingAnchor.constraint(equalTo: pinView.trailingAnchor, constant: 11),
            issueTextField.widthAnchor.constraint(equalToConstant: 220),
            issueTextField.heightAnchor.constraint(equalToConstant: 28),
       
            approvalView.topAnchor.constraint(equalTo: toolbarView.topAnchor, constant: 23),
            approvalView.leadingAnchor.constraint(equalTo: issueTextField.trailingAnchor, constant: 110),
            approvalView.widthAnchor.constraint(equalToConstant: 14),
            approvalView.heightAnchor.constraint(equalToConstant: 14),

            exportButton.topAnchor.constraint(equalTo: toolbarView.topAnchor, constant: 23),
            exportButton.leadingAnchor.constraint(equalTo: approvalView.trailingAnchor, constant: 26),
            exportButton.widthAnchor.constraint(equalToConstant: 14),
            exportButton.heightAnchor.constraint(equalToConstant: 14),

            segmentedControl.topAnchor.constraint(equalTo: toolbarView.bottomAnchor, constant: 7),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            segmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            segmentedControl.heightAnchor.constraint(equalToConstant: 28),

            noteTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 7),
            noteTableView.bottomAnchor.constraint(equalTo: noteControlBar.topAnchor, constant: 0),
            noteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            noteControlBar.topAnchor.constraint(equalTo: noteTableView.bottomAnchor),
            noteControlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteControlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            addMediaButton.bottomAnchor.constraint(equalTo: noteControlBar.bottomAnchor, constant: -11),
            addMediaButton.leadingAnchor.constraint(equalTo: noteControlBar.leadingAnchor, constant: 19),
            addMediaButton.widthAnchor.constraint(equalToConstant: 21),
            addMediaButton.heightAnchor.constraint(equalToConstant: 21),

            addImageButton.bottomAnchor.constraint(equalTo: noteControlBar.bottomAnchor, constant: -11),
            addImageButton.leadingAnchor.constraint(equalTo: addMediaButton.trailingAnchor, constant: 23),
            addImageButton.widthAnchor.constraint(equalToConstant: 21),
            addImageButton.heightAnchor.constraint(equalToConstant: 21),

            noteTextView.bottomAnchor.constraint(equalTo: noteControlBar.bottomAnchor, constant: -8),
            noteTextView.leadingAnchor.constraint(equalTo: addImageButton.trailingAnchor, constant: 20),

            submitTextButton.bottomAnchor.constraint(equalTo: noteControlBar.bottomAnchor, constant: -8),
            submitTextButton.leadingAnchor.constraint(equalTo: noteTextView.trailingAnchor, constant: 6),
            submitTextButton.widthAnchor.constraint(equalToConstant: 28),
            submitTextButton.heightAnchor.constraint(equalToConstant: 28),
            submitTextButton.trailingAnchor.constraint(equalTo: noteControlBar.trailingAnchor, constant: -6),
        ])
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: noteControlBar.bottomAnchor, constant: 0)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
    }

    // MARK: - Public Methods
    public func configure(with pin: Pin, with issue: Issue) {
        issueNotes = IssueNotes(reports: issue.reports, needApproval: issue.needApproval, inspirationBoard: issue.inspirationBoard)
        issueTextField.text = issue.name
        let color = pin.color
        pinView.image = UIImage(named: "Pin")?.withTintColor(color, renderingMode: .alwaysOriginal)
        pinLabel.textAlignment = .center
        pinLabel.font = UIFont.boldSystemFont(ofSize: 16)
        pinLabel.textColor = .white
        pinLabel.text = pin.marker.pinLabel.text
        segmentedControl.setTitle("Reports (\(issueNotes.reports.count))", forSegmentAt: 0)
        segmentedControl.setTitle("Need Approval (\(issueNotes.needApproval.count))", forSegmentAt: 1)
        segmentedControl.setTitle("Inspiration Board (\(issueNotes.inspirationBoard.count))", forSegmentAt: 2)
        noteTableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func updateSegmentedControlTitles() {
        self.segmentedControl.setTitle("Reports (\(self.issueNotes.reports.count))", forSegmentAt: 0)
        self.segmentedControl.setTitle("Need Approval (\(self.issueNotes.needApproval.count))", forSegmentAt: 1)
        self.segmentedControl.setTitle("Inspiration Board (\(self.issueNotes.inspirationBoard.count))", forSegmentAt: 2)
    }
    
    // MARK: - Selectors:
    @objc private func didTapBackButton() {
        delegate?.didTapBackButtonIssue()
    }
    @objc private func didTapNextButton() {
        delegate?.didTapNextButtonIssue()
    }
    @objc private func didTapAddImageButton() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 10
        config.filter = PHPickerFilter.any(of: [.images, .livePhotos, .videos])
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    @objc private func didTapSubmitTextButton() {
        if !noteTextView.text.isEmpty {
            noteTextView.resignFirstResponder()
            let text = noteTextView.text
            delegate?.didAddNoteTextView(text: text ?? "Text", for: issueType)
            issueNotes = (delegate?.fetchNotes())!
            
            switch issueType {
            case .reports:
                issueNotes.reports[issueNotes.reports.count-1].isOpened = true
            case .needApproval:
                issueNotes.needApproval[issueNotes.needApproval.count-1].isOpened = true
            case .inspirationBoard:
                issueNotes.inspirationBoard[issueNotes.inspirationBoard.count-1].isOpened = true
            }
            
            noteTableView.reloadData()
            noteTextView.text?.removeAll()
            
            textViewHeightConstraint.constant = noteTextView.contentSize.height
            controlBarHeightConstraint.constant = noteTextView.contentSize.height + 16
            noteTextView.layoutIfNeeded()
            noteControlBar.layoutIfNeeded()
            
            switch issueType {
            case .reports:
                guard let entries = issueNotes.reports.last?.entries else { fatalError() }
                noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: issueNotes.reports.endIndex-1), at: .bottom, animated: true)
            case .needApproval:
                guard let entries = issueNotes.needApproval.last?.entries else { fatalError() }
                noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: issueNotes.needApproval.endIndex-1), at: .bottom, animated: true)
            case .inspirationBoard:
                guard let entries = issueNotes.inspirationBoard.last?.entries else { fatalError() }
                noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: issueNotes.inspirationBoard.endIndex-1), at: .bottom, animated: true)
            }
            updateSegmentedControlTitles()
            submitTextButton.imageView?.tintColor = .gray
        }
    }
    @objc private func didTapSegmentedControl(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            issueType = .reports
        case 1:
            issueType = .needApproval
        default:
            issueType = .inspirationBoard
        }
        noteTableView.reloadData()
    }
    @objc private func didHoldNoteCell(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: noteTableView)
            if let indexPath = noteTableView.indexPathForRow(at: touchPoint) {
                let ac = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                ac.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                    // TODO: Add edit action
                }))
                ac.addAction(UIAlertAction(title: "Move to Tab", style: .default, handler: { _ in
                    // TODO: Add edit action
                }))
                ac.addAction(UIAlertAction(title: "Copy to Tab", style: .default, handler: { _ in
                    // TODO: Add edit action
                }))
                ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.deleteCell(at: indexPath)
                }))
                let popover = ac.popoverPresentationController
                let cellRect = noteTableView.rectForRow(at: indexPath)
                popover?.sourceView = noteTableView
                popover?.sourceRect = cellRect
                popover?.canOverlapSourceViewRect = true
//                popover?.permittedArrowDirections = UIPopoverArrowDirection.down
                present(ac, animated: true)
            }
        }
    }

    @objc private func didTapExportButton() {
        delegate?.didTapExportButtonIssue()
    }
}
    // MARK: - Table View Delegates
extension IssuePanelViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch issueType {
        case .reports:
            return issueNotes.reports.count
        case .needApproval:
            return issueNotes.needApproval.count
        case .inspirationBoard:
            return issueNotes.inspirationBoard.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch issueType {
        case .reports:
            return issueNotes.reports[section].isOpened ? issueNotes.reports[section].entries.count + 1 : 1
        case .needApproval:
            return issueNotes.needApproval[section].isOpened ? issueNotes.needApproval[section].entries.count + 1 : 1
        case .inspirationBoard:
            return issueNotes.inspirationBoard[section].isOpened ? issueNotes.inspirationBoard[section].entries.count + 1 : 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { fatalError() }
            switch issueType {
            case .reports:
                cell.configure(note: issueNotes.reports[indexPath.item])
                cell.setAccessoryType(with: issueNotes.reports[indexPath.section].isOpened)
            case .needApproval:
                cell.configure(note: issueNotes.needApproval[indexPath.item])
                cell.setAccessoryType(with: issueNotes.needApproval[indexPath.section].isOpened)
            case .inspirationBoard:
                cell.configure(note: issueNotes.inspirationBoard[indexPath.item])
                cell.setAccessoryType(with: issueNotes.inspirationBoard[indexPath.section].isOpened)
            }
            return cell
        } else {
            let note: NoteType
            switch issueType {
            case .reports:
                note = issueNotes.reports[indexPath.section].entries[indexPath.row - 1]
            case .needApproval:
                note = issueNotes.needApproval[indexPath.section].entries[indexPath.row - 1]
            case .inspirationBoard:
                note = issueNotes.inspirationBoard[indexPath.section].entries[indexPath.row - 1]
            }
            if note.text != nil {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailTableViewCell.identifier, for: indexPath) as? NoteDetailTableViewCell else { fatalError() }
                cell.configure(note: note)
                cell.layoutIfNeeded()
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteMediaTableViewCell.identifier, for: indexPath) as? NoteMediaTableViewCell else { fatalError() }
                cell.configure(note: note)
                cell.noteIndex = indexPath
                cell.delegate = self
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return }
        if indexPath.row != 0 { return }
        let sections = IndexSet.init(integer: indexPath.section)
        switch issueType {
        case .reports:
            issueNotes.reports[indexPath.section].isOpened.toggle()
            cell.setAccessoryType(with: issueNotes.reports[indexPath.section].isOpened)
        case .needApproval:
            issueNotes.needApproval[indexPath.section].isOpened.toggle()
            cell.setAccessoryType(with: issueNotes.needApproval[indexPath.section].isOpened)
        case .inspirationBoard:
            issueNotes.inspirationBoard[indexPath.section].isOpened.toggle()
            cell.setAccessoryType(with: issueNotes.inspirationBoard[indexPath.section].isOpened)
        }
        tableView.reloadSections(sections, with: .automatic)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            self.deleteCell(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            guard let cell = tableView.cellForRow(at: indexPath) as? NoteDetailTableViewCell else { return }
            // get current text from entry into textview
            let currentText: String?
            switch self.issueType {
            case .reports:
                currentText = self.issueNotes.reports[indexPath.section].entries[indexPath.row-1].text
            case .needApproval:
                currentText = self.issueNotes.needApproval[indexPath.section].entries[indexPath.row-1].text
            case .inspirationBoard:
                currentText = self.issueNotes.inspirationBoard[indexPath.section].entries[indexPath.row-1].text
            }
            self.noteTextView.text = currentText
            self.isEditingEntry = true
            // update entry cell UI to display editing mode
            cell.setHighlight(isHighlighted: true)
            self.noteTableView.reloadRows(at: [indexPath], with: .automatic)
            // open keyboard and set focus on entry
            self.noteTextView.becomeFirstResponder()
            self.noteTableView.scrollToRow(at: IndexPath(row: indexPath.row-1, section: indexPath.section), at: .bottom, animated: true)
            // update current entry with new entry
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
    private func deleteCell(at indexPath: IndexPath) {
        guard let cell = noteTableView.cellForRow(at: indexPath) else { return }
        if cell.isKind(of: NoteDetailTableViewCell.self) || cell.isKind(of: NoteMediaTableViewCell.self) {
            delegate?.didDeleteEntry(indexPath: indexPath, for: issueType)
        } else {
            delegate?.didDeleteNote(indexPath: indexPath, for: issueType)
        }
        issueNotes = (delegate?.fetchNotes())!
        updateSegmentedControlTitles()
        noteTableView.reloadData()
    }
}

// MARK: - Issue Text Field Delegate
extension IssuePanelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        issueTextField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == issueTextField {
            let name = issueTextField.text
            delegate?.didUpdateIssueTextField(name: name ?? "Issue Title")
        }
    }
}

// MARK: - Note Text View Delegate
extension IssuePanelViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        noteTextView.resignFirstResponder()
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            submitTextButton.imageView?.tintColor = .gray
        } else {
            submitTextButton.imageView?.tintColor = .systemBlue
        }
        let numberOfLines = textView.contentSize.height/(textView.font?.lineHeight)!
        if Int(numberOfLines) > 6 {
            textViewHeightConstraint.constant = heightForTextView
            controlBarHeightConstraint.constant = heightForControlBar
        } else {
            if Int(numberOfLines) == 6 {
                heightForTextView = textView.contentSize.height
                heightForControlBar = textView.contentSize.height + 16
            }
            textViewHeightConstraint.constant = textView.contentSize.height
            controlBarHeightConstraint.constant = textView.contentSize.height + 16
        }
        noteTextView.layoutIfNeeded()
        noteControlBar.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch issueType {
        case .reports:
            guard let note = issueNotes.reports.last, note.isOpened == true else { return }
            guard let entries = issueNotes.reports.last?.entries else { return }
            noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: issueNotes.reports.endIndex-1), at: .bottom, animated: true)
        case .needApproval:
            guard let note = issueNotes.needApproval.last, note.isOpened == true else { return }
            guard let entries = issueNotes.needApproval.last?.entries else { return }
            noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: issueNotes.needApproval.endIndex-1), at: .bottom, animated: true)
        case .inspirationBoard:
            guard let note = issueNotes.inspirationBoard.last, note.isOpened == true else { return }
            guard let entries = issueNotes.inspirationBoard.last?.entries else { return }
            noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: issueNotes.inspirationBoard.endIndex-1), at: .bottom, animated: true)
        }
    }
}

// MARK: - Photo Picker Delegate
extension IssuePanelViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var images = [UIImage]()
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    group.leave()
                }
                guard let image = reading as? UIImage , error == nil else {
                    return
                }
                images.append(image)
            }
        }
        group.notify(queue: .main) {
            if images.isEmpty { return }
            self.delegate?.didAddMediaToNote(images: images, for: self.issueType)
            self.issueNotes = (self.delegate?.fetchNotes())!
            switch self.issueType {
            case .reports:
                self.issueNotes.reports[self.issueNotes.reports.count-1].isOpened = true
                self.noteTableView.reloadData()
                guard let entries = self.issueNotes.reports.last?.entries else { fatalError() }
                self.noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: self.issueNotes.reports.endIndex-1), at: .bottom, animated: true)
            case .needApproval:
                self.issueNotes.needApproval[self.issueNotes.needApproval.count-1].isOpened = true
                self.noteTableView.reloadData()
                guard let entries = self.issueNotes.needApproval.last?.entries else { fatalError() }
                self.noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: self.issueNotes.needApproval.endIndex-1), at: .bottom, animated: true)
            case .inspirationBoard:
                self.issueNotes.inspirationBoard[self.issueNotes.inspirationBoard.count-1].isOpened = true
                self.noteTableView.reloadData()
                guard let entries = self.issueNotes.inspirationBoard.last?.entries else { fatalError() }
                self.noteTableView.scrollToRow(at: IndexPath(row: entries.endIndex, section: self.issueNotes.inspirationBoard.endIndex-1), at: .bottom, animated: true)
            }
            self.updateSegmentedControlTitles()
        }
    }
}

// MARK: - Note Media Table View Cell Delegate
extension IssuePanelViewController: NoteMediaTableViewCellDelegate {
    func presentPhotoEditor(with image: UIImage, photoIndex: IndexPath, noteIndex: IndexPath) {
        let photoEditorVC = PhotoEditorViewController()
        photoEditorVC.configure(with: image, photoIndex: photoIndex, noteIndex: noteIndex)
        photoEditorVC.delegate = self
        let nav = UINavigationController(rootViewController: photoEditorVC)
        nav.modalPresentationStyle = .automatic
        present(nav, animated: true)
    }
}

// MARK: - Photo Editor View Controller Delegate
extension IssuePanelViewController: PhotoEditorViewControllerDelegate {
    func deleteImage(photoIndex: IndexPath, noteIndex: IndexPath) {
        delegate?.didDeleteImageFromEntry(photoIndex: photoIndex, noteIndex: noteIndex, for: issueType)
        issueNotes = (delegate?.fetchNotes())!
        noteTableView.reloadData()
    }
    func replaceImage(with image: UIImage, noteIndex: IndexPath, photoIndex: IndexPath) {
        delegate?.replaceImage(with: image, photoIndex: photoIndex, noteIndex: noteIndex, for: issueType)
        issueNotes = (delegate?.fetchNotes())!
        noteTableView.reloadData()
    }
}

// MARK: - Context Menu
extension IssuePanelViewController {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil"), state: .off) { _ in
                // TODO: Edit Action
            }
            let deleteAction = UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive, state: .off) { _ in
                self.deleteCell(at: indexPath)
            }
            let actionSubMenu = UIMenu(title: "", options: .displayInline, children: [editAction, deleteAction])
            let moveSubMenu = self.createMoveSubMenu(indexPath: indexPath)
            let copySubMenu = self.createCopySubMenu(indexPath: indexPath)
            return UIMenu(title: "", children: [actionSubMenu, moveSubMenu, copySubMenu])
        }
        return config
    }
    private func createMoveSubMenu(indexPath: IndexPath) -> UIMenu {
        var moveTitles = [String]()
        for index in 0...2 {
            if index != segmentedControl.selectedSegmentIndex {
                moveTitles.append(segmentedControl.titleForSegment(at: index)!)
            }
        }
        var moveActions = [UIMenuElement]()
        for title in moveTitles {
            let identifier: String
            if title.contains("Reports") {
                identifier = "0"
            } else if title.contains("Need Approval") {
                identifier = "1"
            } else {
                identifier = "2"
            }
            let moveAction = UIAction(title: title, identifier: UIAction.Identifier(identifier), state: .off) { action in
                self.moveToTabAction(from: action, indexPath: indexPath)
            }
            moveActions.append(moveAction)
        }
        let menu = UIMenu(title: "Move to tab", options: .singleSelection, children: moveActions)
        return menu
    }
    private func moveToTabAction(from action: UIAction, indexPath: IndexPath) {
        guard let destinationIndex = Int(action.identifier.rawValue) else { return }
        let destinationType: IssueType
        switch destinationIndex {
        case 0:
            destinationType = .reports
        case 1:
            destinationType = .needApproval
        default:
            destinationType = .inspirationBoard
        }
        // check if note or media or issue
        guard let cell = noteTableView.cellForRow(at: indexPath) else { return }
        // copy note to tab, create new issue if necessary, then delete
        if cell.isKind(of: NoteDetailTableViewCell.self) || cell.isKind(of: NoteMediaTableViewCell.self) {
            delegate?.didCopyEntry(indexPath: indexPath, origin: issueType, destination: destinationType)
            delegate?.didDeleteEntry(indexPath: indexPath, for: issueType)
        } else {
            // TODO: didCopyNote
        }
        issueNotes = (delegate?.fetchNotes())!
        updateSegmentedControlTitles()
        segmentedControl.selectedSegmentIndex = destinationIndex
        issueType = destinationType
        noteTableView.reloadData()
    }
    private func createCopySubMenu(indexPath: IndexPath) -> UIMenu {
        var copyTitles = [String]()
        for index in 0...2 {
            if index != segmentedControl.selectedSegmentIndex {
                copyTitles.append(segmentedControl.titleForSegment(at: index)!)
            }
        }
        var copyActions = [UIMenuElement]()
        for title in copyTitles {
            let identifier: String
            if title.contains("Reports") {
                identifier = "0"
            } else if title.contains("Need Approval") {
                identifier = "1"
            } else {
                identifier = "2"
            }
            let copyAction = UIAction(title: title, identifier: UIAction.Identifier(identifier), state: .off) { action in
                self.copyToTabAction(from: action, indexPath: indexPath)
            }
            copyActions.append(copyAction)
        }
        let menu = UIMenu(title: "Copy to tab", options: .singleSelection, children: copyActions)
        return menu
    }
    private func copyToTabAction(from action: UIAction, indexPath: IndexPath) {
        guard let destinationIndex = Int(action.identifier.rawValue) else { return }
        let destinationType: IssueType
        switch destinationIndex {
        case 0:
            destinationType = .reports
        case 1:
            destinationType = .needApproval
        default:
            destinationType = .inspirationBoard
        }
        // check if note or media or issue
        guard let cell = noteTableView.cellForRow(at: indexPath) else { return }
        // copy note to tab, create new issue if necessary, then delete
        if cell.isKind(of: NoteDetailTableViewCell.self) || cell.isKind(of: NoteMediaTableViewCell.self) {
            delegate?.didCopyEntry(indexPath: indexPath, origin: issueType, destination: destinationType)
        } else {
            // TODO: didCopyNote
        }
        issueNotes = (delegate?.fetchNotes())!
        updateSegmentedControlTitles()
        segmentedControl.selectedSegmentIndex = destinationIndex
        issueType = destinationType
        noteTableView.reloadData()
    }
}
