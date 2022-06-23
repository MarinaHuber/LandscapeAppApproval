//
//  MenuViewController.swift
//  LandscapeApp
//
//  Created by Max Park on 5/15/22.
//

import UIKit

// MARK: - Protocols
protocol MenuViewControllerDelegate: AnyObject {
    func openIssuePanel()
    func configureIssuePanel(with pin: Pin, with issue: Issue)
    func addMarkerToMap(marker: Marker)
}

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: MenuViewControllerDelegate?
    var project: Project?
    var pins: [Pin] = []
    var selectedPin: Int?
    var selectedIssue: Int?
    let cellHeight: CGFloat = 44
    let menuWidth: CGFloat = 244
    
    // MARK: - UI Components
    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    private let addPinButton: UIButton = CustomImageButton(image: UIImage(systemName: "plus"), contentMode: .scaleAspectFill)
    private let issueLabel = UILabel()
    private let issueLabelView = UIView()
    private let addIssueButton: UIButton = CustomImageButton(image: UIImage(systemName: "plus"), contentMode: .scaleAspectFill)
    private let issueFilter = IssueFilterButton()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "NavigationGray")
        configureCollectionView()
        configureTableView()
        configureLabel()
        setupViews()
        configureButtons()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Private Methods
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PinCollectionViewCell.self, forCellWithReuseIdentifier: PinCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "NavigationGray")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureTableView() {
        // MARK: Table View
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
        tableView.backgroundColor = Color.SelectedCellColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func configureLabel() {
        issueLabel.text = "New Pin"
        issueLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        issueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        issueLabelView.backgroundColor = Color.SelectedCellColor
        issueLabelView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViews() {
        view.addSubview(issueFilter)
        view.addSubview(addPinButton)
        view.addSubview(issueLabelView)
        issueLabelView.addSubview(issueLabel)
        view.addSubview(addIssueButton)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            issueFilter.topAnchor.constraint(equalTo: view.topAnchor),
            issueFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            issueFilter.widthAnchor.constraint(equalTo: view.widthAnchor),
            issueFilter.heightAnchor.constraint(equalToConstant: cellHeight),
            
            addPinButton.topAnchor.constraint(equalTo: issueFilter.bottomAnchor),
            addPinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addPinButton.widthAnchor.constraint(equalToConstant: cellHeight),
            addPinButton.heightAnchor.constraint(equalToConstant: cellHeight),
            
            issueLabelView.topAnchor.constraint(equalTo: issueFilter.bottomAnchor),
            issueLabelView.leadingAnchor.constraint(equalTo: addPinButton.trailingAnchor),
            issueLabelView.widthAnchor.constraint(equalToConstant: menuWidth - cellHeight - cellHeight),
            issueLabelView.heightAnchor.constraint(equalToConstant: cellHeight),
            
            issueLabel.centerYAnchor.constraint(equalTo: issueLabelView.centerYAnchor),
            issueLabel.leadingAnchor.constraint(equalTo: issueLabelView.leadingAnchor, constant: 20),
            issueLabel.heightAnchor.constraint(equalToConstant: cellHeight),
            
            addIssueButton.topAnchor.constraint(equalTo: issueFilter.bottomAnchor),
            addIssueButton.leadingAnchor.constraint(equalTo: issueLabelView.trailingAnchor),
            addIssueButton.widthAnchor.constraint(equalToConstant: cellHeight),
            addIssueButton.heightAnchor.constraint(equalToConstant: cellHeight),
            
            collectionView.topAnchor.constraint(equalTo: addPinButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.widthAnchor.constraint(equalTo: addPinButton.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: addIssueButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: menuWidth - cellHeight),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureButtons() {
        addIssueButton.backgroundColor = Color.SelectedCellColor
        
        addPinButton.addTarget(self, action: #selector(didTapAddPinButton), for: .touchUpInside)
        addIssueButton.addTarget(self, action: #selector(didTapAddIssueButton), for: .touchUpInside)
    }
    
    private func createPinModel() {
        //        let index = pins.count
        let color = UIColor.systemBlue
        let pin = Pin(id: UUID(), color: color, issues: [], marker: Marker(color: color))
        pin.marker.tag = pins.count
        pin.marker.pinLabel.text = String(Alphabet().singleLetters[pins.count])
        pins.append(pin)
        selectedPin = pins.count-1
        addMarkerToMap(marker: pin.marker)
        print(pin)
        print(pin.marker)
    }
    private func createIssueModel() {
        guard let index = selectedPin else { return }
        let issue = Issue(
            id: UUID(),
            name: "Issue \(pins[index].issues.count)",
            status: .open,
            reports: [],
            needApproval: [],
            inspirationBoard: []
        )
        pins[index].issues.append(issue)
        selectedIssue = pins[index].issues.count-1
    }
    private func selectNewPinAndIssue() {
        // Select Pin and Issue that was created
        let pinIndex = IndexPath(row: pins.count-1, section: 0)
        let issueIndex = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: pinIndex, animated: false, scrollPosition: .top)
        tableView.selectRow(at: issueIndex, animated: false, scrollPosition: .none)
    }
    private func selectNewIssue() {
        // Select Issue that was created
        guard let recentPin = selectedPin else { return }
        let issueIndex = IndexPath(row: pins[recentPin].issues.count - 1, section: 0)
        tableView.selectRow(at: issueIndex, animated: false, scrollPosition: .none)
    }
    private func configureIssuePanel() {
        guard let index = selectedPin else { return }
        let pin = pins[index]
        let issue = pin.issues[selectedIssue!]
        delegate?.configureIssuePanel(with: pin,with: issue)
    }
    private func openIssuePanel() {
        delegate?.openIssuePanel()
    }
    
    // MARK: - Selectors
    
    /// Adding a new pin will also add a new issue
    @objc private func didTapAddPinButton() {
        createPinModel()
        createIssueModel()
        collectionView.reloadData()
        tableView.reloadData()
        selectNewPinAndIssue()
        configureIssuePanel()
        openIssuePanel()
    }
    @objc private func didTapAddIssueButton() {
        createIssueModel()
        tableView.reloadData()
        selectNewIssue()
        configureIssuePanel()
    }
}

// MARK: - Public Methods
extension MenuViewController {
    public func selectPreviousIssue() {
        guard var issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        issueIndex = issueIndex == 0 ? pins[pinIndex].issues.count - 1 : issueIndex - 1
        selectedIssue = issueIndex
        tableView.selectRow(at: IndexPath(row: issueIndex, section: 0), animated: false, scrollPosition: .none)
        configureIssuePanel()
    }
    public func selectNextIssue() {
        guard var issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        issueIndex = issueIndex == pins[pinIndex].issues.count - 1 ? 0 : issueIndex + 1
        selectedIssue = issueIndex
        tableView.selectRow(at: IndexPath(row: issueIndex, section: 0), animated: false, scrollPosition: .none)
        configureIssuePanel()
    }
    public func updateIssueName(name: String) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        pins[pinIndex].issues[issueIndex].name = name
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: issueIndex, section: 0), animated: false, scrollPosition: .none)
    }
    public func addNoteToIssue(text: String, for type: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        // check if note for today exists
        let issue = pins[pinIndex].issues[issueIndex]
        var noteExists: Bool = false
        switch type {
        case .reports:
            for note in issue.reports {
                noteExists = Calendar.current.isDateInToday(note.date) ? true : false
            }
            if noteExists {
                // Create new note
                let noteIndex = issue.reports.count - 1
                pins[pinIndex].issues[issueIndex].reports[noteIndex].entries.append(TextNote(date: Date(), text: text))
            } else {
                // Add entry to existing note
                let note = Note(date: Date(), entries: [TextNote(date: Date(), text: text)])
                pins[pinIndex].issues[issueIndex].reports.append(note)
            }
        case .needApproval:
            for note in issue.needApproval {
                noteExists = Calendar.current.isDateInToday(note.date) ? true : false
            }
            if noteExists {
                // Create new note
                let noteIndex = issue.needApproval.count - 1
                pins[pinIndex].issues[issueIndex].needApproval[noteIndex].entries.append(TextNote(date: Date(), text: text))
            } else {
                // Add entry to existing note
                let note = Note(date: Date(), entries: [TextNote(date: Date(), text: text)])
                pins[pinIndex].issues[issueIndex].needApproval.append(note)
            }
        case .inspirationBoard:
            for note in issue.inspirationBoard {
                noteExists = Calendar.current.isDateInToday(note.date) ? true : false
            }
            if noteExists {
                // Create new note
                let noteIndex = issue.inspirationBoard.count - 1
                pins[pinIndex].issues[issueIndex].inspirationBoard[noteIndex].entries.append(TextNote(date: Date(), text: text))
            } else {
                // Add entry to existing note
                let note = Note(date: Date(), entries: [TextNote(date: Date(), text: text)])
                pins[pinIndex].issues[issueIndex].inspirationBoard.append(note)
            }
        }
    }
    public func addMediaToNote(images: [UIImage], for type: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        let issue = pins[pinIndex].issues[issueIndex]
        var noteExists: Bool = false
        switch type {
        case .reports:
            for note in issue.reports {
                noteExists = Calendar.current.isDateInToday(note.date) ? true : false
            }
            if noteExists {
                // Create new note
                let noteIndex = issue.reports.count - 1
                pins[pinIndex].issues[issueIndex].reports[noteIndex].entries.append(TextNote(date: Date(), images: images))
            } else {
                // Add entry to existing note
                let note = Note(date: Date(), entries: [TextNote(date: Date(), images: images)])
                pins[pinIndex].issues[issueIndex].reports.append(note)
            }
        case .needApproval:
            for note in issue.needApproval {
                noteExists = Calendar.current.isDateInToday(note.date) ? true : false
            }
            if noteExists {
                // Create new note
                let noteIndex = issue.needApproval.count - 1
                pins[pinIndex].issues[issueIndex].needApproval[noteIndex].entries.append(TextNote(date: Date(), images: images))
            } else {
                // Add entry to existing note
                let note = Note(date: Date(), entries: [TextNote(date: Date(), images: images)])
                pins[pinIndex].issues[issueIndex].needApproval.append(note)
            }
        case .inspirationBoard:
            for note in issue.inspirationBoard {
                noteExists = Calendar.current.isDateInToday(note.date) ? true : false
            }
            if noteExists {
                // Create new note
                let noteIndex = issue.inspirationBoard.count - 1
                pins[pinIndex].issues[issueIndex].inspirationBoard[noteIndex].entries.append(TextNote(date: Date(), images: images))
            } else {
                // Add entry to existing note
                let note = Note(date: Date(), entries: [TextNote(date: Date(), images: images)])
                pins[pinIndex].issues[issueIndex].inspirationBoard.append(note)
            }
        }
    }
    public func deleteEntryFromNote(indexPath: IndexPath, for type: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        switch type {
        case .reports:
            pins[pinIndex].issues[issueIndex].reports[indexPath.section].entries.remove(at: indexPath.row-1)
            if pins[pinIndex].issues[issueIndex].reports[indexPath.section].entries.isEmpty {
                pins[pinIndex].issues[issueIndex].reports.remove(at: indexPath.section)
            }
        case .needApproval:
            pins[pinIndex].issues[issueIndex].needApproval[indexPath.section].entries.remove(at: indexPath.row-1)
            if pins[pinIndex].issues[issueIndex].needApproval[indexPath.section].entries.isEmpty {
                pins[pinIndex].issues[issueIndex].needApproval.remove(at: indexPath.section)
            }
        case .inspirationBoard:
            pins[pinIndex].issues[issueIndex].inspirationBoard[indexPath.section].entries.remove(at: indexPath.row-1)
            if pins[pinIndex].issues[issueIndex].inspirationBoard[indexPath.section].entries.isEmpty {
                pins[pinIndex].issues[issueIndex].inspirationBoard.remove(at: indexPath.section)
            }
        }
    }
    public func deleteNoteFromIssue(indexPath: IndexPath, for type: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        switch type {
        case .reports:
            pins[pinIndex].issues[issueIndex].reports.remove(at: indexPath.section)
        case .needApproval:
            pins[pinIndex].issues[issueIndex].needApproval.remove(at: indexPath.section)
        case .inspirationBoard:
            pins[pinIndex].issues[issueIndex].inspirationBoard.remove(at: indexPath.section)
        }
    }
    public func fetchNotes() -> IssueNotes {
        guard let issueIndex = selectedIssue else { return IssueNotes(reports: [], needApproval: [], inspirationBoard: []) }
        guard let pinIndex = selectedPin else { return IssueNotes(reports: [], needApproval: [], inspirationBoard: []) }
        let issue = pins[pinIndex].issues[issueIndex]
        return IssueNotes(reports: issue.reports, needApproval: issue.needApproval, inspirationBoard: issue.inspirationBoard)
    }
    public func replaceImage(with image: UIImage, photoIndex: IndexPath, noteIndex: IndexPath, for type: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        switch type {
        case .reports:
            pins[pinIndex].issues[issueIndex].reports[noteIndex.section].entries[noteIndex.row-1].images![photoIndex.item] = image
        case .needApproval:
            pins[pinIndex].issues[issueIndex].needApproval[noteIndex.section].entries[noteIndex.row-1].images![photoIndex.item] = image
        case .inspirationBoard:
            pins[pinIndex].issues[issueIndex].inspirationBoard[noteIndex.section].entries[noteIndex.row-1].images![photoIndex.item] = image
        }
    }
    func deleteImageFromEntry(photoIndex: IndexPath, noteIndex: IndexPath, for type: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        switch type {
        case .reports:
            pins[pinIndex].issues[issueIndex].reports[noteIndex.section].entries[noteIndex.row-1].images?.remove(at: photoIndex.item)
            if pins[pinIndex].issues[issueIndex].reports[noteIndex.section].entries.isEmpty {
                pins[pinIndex].issues[issueIndex].reports.remove(at: noteIndex.section)
            }
        case .needApproval:
            pins[pinIndex].issues[issueIndex].needApproval[noteIndex.section].entries[noteIndex.row-1].images?.remove(at: photoIndex.item)
            if pins[pinIndex].issues[issueIndex].needApproval[noteIndex.section].entries.isEmpty {
                pins[pinIndex].issues[issueIndex].needApproval.remove(at: noteIndex.section)
            }
        case .inspirationBoard:
            pins[pinIndex].issues[issueIndex].inspirationBoard[noteIndex.section].entries[noteIndex.row-1].images?.remove(at: photoIndex.item)
            if pins[pinIndex].issues[issueIndex].inspirationBoard[noteIndex.section].entries.isEmpty {
                pins[pinIndex].issues[issueIndex].inspirationBoard.remove(at: noteIndex.section)
            }
        }
    }
    func copyEntryToTab(indexPath: IndexPath, origin: IssueType, destination: IssueType) {
        guard let issueIndex = selectedIssue, let pinIndex = selectedPin else { return }
        switch origin {
        case .reports:
            // get entry to copy
            let entry = pins[pinIndex].issues[issueIndex].reports[indexPath.section].entries[indexPath.row-1]
            let note = Note(date: Date(), entries: [entry])
            // check if desintation has note
            switch destination {
            case .needApproval:
                if pins[pinIndex].issues[issueIndex].needApproval.isEmpty {
                    // if note does not exist, create new note, and append
                    pins[pinIndex].issues[issueIndex].needApproval.append(note)
                } else {
                    // if note exists, add to entries
                    pins[pinIndex].issues[issueIndex].needApproval[indexPath.section].entries.append(entry)
                }
            case .inspirationBoard:
                if pins[pinIndex].issues[issueIndex].inspirationBoard.isEmpty {
                    // if note does not exist, create new note, and append
                    pins[pinIndex].issues[issueIndex].inspirationBoard.append(note)
                } else {
                    // if note exists, add to entries
                    pins[pinIndex].issues[issueIndex].inspirationBoard[indexPath.section].entries.append(entry)
                }
            default:
                return
            }
        case .needApproval:
            let entry = pins[pinIndex].issues[issueIndex].needApproval[indexPath.section].entries[indexPath.row-1]
            let note = Note(date: Date(), entries: [entry])
            switch destination {
            case .reports:
                if pins[pinIndex].issues[issueIndex].reports.isEmpty {
                    pins[pinIndex].issues[issueIndex].reports.append(note)
                } else {
                    pins[pinIndex].issues[issueIndex].reports[indexPath.section].entries.append(entry)
                }
            case .inspirationBoard:
                if pins[pinIndex].issues[issueIndex].inspirationBoard.isEmpty {
                    pins[pinIndex].issues[issueIndex].inspirationBoard.append(note)
                } else {
                    pins[pinIndex].issues[issueIndex].inspirationBoard[indexPath.section].entries.append(entry)
                }
            default:
                return
            }
        case .inspirationBoard:
            let entry = pins[pinIndex].issues[issueIndex].inspirationBoard[indexPath.section].entries[indexPath.row-1]
            let note = Note(date: Date(), entries: [entry])
            switch destination {
            case .reports:
                if pins[pinIndex].issues[issueIndex].reports.isEmpty {
                    pins[pinIndex].issues[issueIndex].reports.append(note)
                } else {
                    pins[pinIndex].issues[issueIndex].reports[indexPath.section].entries.append(entry)
                }
            case .needApproval:
                if pins[pinIndex].issues[issueIndex].needApproval.isEmpty {
                    pins[pinIndex].issues[issueIndex].needApproval.append(note)
                } else {
                    pins[pinIndex].issues[issueIndex].needApproval[indexPath.section].entries.append(entry)
                }
            default:
                return
            }
        }
    }
    public func retrieveMarkers() -> [Marker] {
        return pins.map { $0.marker }
    }
    public func addMarkerToMap(marker: Marker) {
        print(marker)
        delegate?.addMarkerToMap(marker: marker)
    }
    public func deselectAllPins(except pinIndex: Int) {
        for (index, pin) in pins.enumerated() {
            if index != pinIndex {
                pin.marker.isSelected = false
            }
        }
        selectPin(pinIndex: pinIndex)
        
    }
    public func selectPin(pinIndex: Int) {
        selectedPin = pinIndex
        collectionView.selectItem(at: IndexPath(item: pinIndex, section: 0), animated: false, scrollPosition: .top)
        selectedIssue = 0
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        configureIssuePanel()
    }
}

// MARK: - Collection View Delegates
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PinCollectionViewCell.identifier,
            for: indexPath
        ) as? PinCollectionViewCell else {
            fatalError()
        }
        let model = pins[indexPath.item]
        cell.configure(with: model)
        if selectedPin != indexPath.item {
            cell.isSelected = false
            pins[indexPath.item].marker.isSelected = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update table view with Issue Models
        if selectedPin != indexPath.item {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PinCollectionViewCell else { return }
            cell.isSelected = true
            pins[indexPath.item].marker.isSelected = true
            deselectAllPins(except: indexPath.item)
            selectedPin = indexPath.item
            selectedIssue = 0
            tableView.reloadData()
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            configureIssuePanel()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Table View Delegates
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let index = selectedPin else { return 0 }
        return pins[index].issues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: IssueTableViewCell.identifier,
            for: indexPath
        ) as? IssueTableViewCell else {
            fatalError()
        }
        let model = pins[selectedPin!].issues[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIssue = indexPath.row
        configureIssuePanel()
    }
}
