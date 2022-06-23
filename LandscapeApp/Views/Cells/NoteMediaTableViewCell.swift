//
//  NoteImagesTableViewCell.swift
//  LandscapeApp
//
//  Created by Max Park on 5/31/22.
//

import UIKit

protocol NoteMediaTableViewCellDelegate: AnyObject {
    func presentPhotoEditor(with image: UIImage, photoIndex: IndexPath, noteIndex: IndexPath)
}

class NoteMediaTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "NoteMediaTableViewCell"
    weak var delegate: NoteMediaTableViewCellDelegate?
    var noteIndex = IndexPath()
    private var images = [UIImage]()
    
    // MARK: - UI Components
    private let cellView: UIView = CustomView(color: .white, cornerRadius: 4)
    private let infoHeaderView: UIView = CustomView(color: .white, cornerRadius: 0)
    private let imagesIcon: UIImageView = CustomImageView(
        image: UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray),
        contentMode: .scaleAspectFit
    )
    private let imagesLabel: UILabel = CustomMediaLabel()
    private let videosIcon: UIImageView = CustomImageView(
        image: UIImage(systemName: "play.rectangle.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray),
        contentMode: .scaleAspectFit
    )
    private let videosLabel: UILabel = CustomMediaLabel()
    private let dateLabel: UILabel = CustomDateLabel()
    let mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EntryMediaCollectionViewCell.self, forCellWithReuseIdentifier: EntryMediaCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Object Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "IssuePanelBackground")
        selectionStyle = .none
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        
        contentView.addSubview(cellView)
        cellView.addSubview(infoHeaderView)
        infoHeaderView.addSubview(imagesIcon)
        infoHeaderView.addSubview(imagesLabel)
        infoHeaderView.addSubview(videosIcon)
        infoHeaderView.addSubview(videosLabel)
        infoHeaderView.addSubview(dateLabel)
        cellView.addSubview(mediaCollectionView)
        
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        NSLayoutConstraint.activate([
            infoHeaderView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            infoHeaderView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            infoHeaderView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
        ])
        NSLayoutConstraint.activate([
            imagesIcon.topAnchor.constraint(equalTo: infoHeaderView.topAnchor, constant: 0),
            imagesIcon.bottomAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            imagesIcon.leadingAnchor.constraint(equalTo: infoHeaderView.leadingAnchor, constant: 2),
            imagesIcon.widthAnchor.constraint(equalToConstant: 14)
        ])
        NSLayoutConstraint.activate([
            imagesLabel.topAnchor.constraint(equalTo: infoHeaderView.topAnchor),
            imagesLabel.bottomAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            imagesLabel.leadingAnchor.constraint(equalTo: imagesIcon.trailingAnchor, constant: 6),
            imagesLabel.widthAnchor.constraint(equalToConstant: 12)
        ])
        NSLayoutConstraint.activate([
            videosIcon.topAnchor.constraint(equalTo: infoHeaderView.topAnchor),
            videosIcon.bottomAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            videosIcon.leadingAnchor.constraint(equalTo: imagesLabel.trailingAnchor, constant: 10),
            videosIcon.widthAnchor.constraint(equalToConstant: 14)
        ])
        NSLayoutConstraint.activate([
            videosLabel.topAnchor.constraint(equalTo: infoHeaderView.topAnchor),
            videosLabel.bottomAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            videosLabel.leadingAnchor.constraint(equalTo: videosIcon.trailingAnchor, constant: 6),
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: infoHeaderView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: videosLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: infoHeaderView.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            mediaCollectionView.topAnchor.constraint(equalTo: infoHeaderView.bottomAnchor),
            mediaCollectionView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            mediaCollectionView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            mediaCollectionView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            mediaCollectionView.heightAnchor.constraint(equalToConstant: 78+16)
        ])
    }
    
    // MARK: - Methods
    private func configureLabels() {
        imagesLabel.text = "0"
        videosLabel.text = "0"
    }
    public func configure(note: NoteType) {
        let date = note.date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        dateLabel.text = formatter.string(from: date)
        guard let images = note.images else { return }
        self.images = images
        imagesLabel.text = String(images.count)
        mediaCollectionView.reloadData()
    }
}

// MARK: - Collection View Delegates
extension NoteMediaTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EntryMediaCollectionViewCell.identifier, for: indexPath) as? EntryMediaCollectionViewCell else {
            fatalError()
        }
        cell.configure(image: images[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        delegate?.presentPhotoEditor(with: image, photoIndex: indexPath, noteIndex: noteIndex)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 104, height: 78)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
