//
//  PhotoEditorViewController.swift
//  LandscapeApp
//
//  Created by Max Park on 6/7/22.
//

import UIKit
import PencilKit

// MARK: - Protocols
protocol PhotoEditorViewControllerDelegate: AnyObject {
    func replaceImage(with image: UIImage, noteIndex: IndexPath , photoIndex: IndexPath)
    func deleteImage(photoIndex: IndexPath, noteIndex: IndexPath)
}

class PhotoEditorViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: PhotoEditorViewControllerDelegate?
    private var indexOfImage: IndexPath = IndexPath()
    private var indexOfNote: IndexPath = IndexPath()
    private var imageToEdit: UIImage?
    private var isEditActive: Bool = false
    
    // MARK: - UI Components
    private var imageView: UIImageView = CustomImageView(image: nil, contentMode: .scaleAspectFit)
    private var canvasView: PKCanvasView = {
        let view = PKCanvasView()
        view.isOpaque = false
        view.drawingPolicy = PKCanvasViewDrawingPolicy.anyInput
        return view
    }()
    private let toolPicker = PKToolPicker()
    private let clearButton: UIButton = CustomButton(title: "Clear", titleColor: .systemBlue, font: nil)
    private let saveButton: UIButton = CustomButton(title: "Save", titleColor: .systemBlue, font: nil)
    private let cancelButton: UIButton = CustomButton(title: "Cancel", titleColor: .systemBlue, font: nil)
        
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Photo"
        view.backgroundColor = UIColor(named: "IssuePanelBackground")
        navigationController?.navigationBar.backgroundColor = UIColor(named: "NavigationGray")
        view.addSubview(imageView)
        addBarButtonItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.width),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    // MARK: - Public Methods
    public func configure(with image: UIImage, photoIndex: IndexPath, noteIndex: IndexPath) {
        self.imageToEdit = image
        self.indexOfImage = photoIndex
        self.indexOfNote = noteIndex
        imageView.image = imageToEdit
    }
    
    // MARK: - Private Methods
    private func addBarButtonItems() {
        let backButton = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        let annotationButton = UIBarButtonItem(
            image: UIImage(systemName: "paintbrush.pointed.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapAnnotationButton)
        )
        let deleteButton = UIBarButtonItem(
            title: "Delete",
            style: .plain,
            target: self,
            action: #selector(didTapDeleteButton)
        )
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 50
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [annotationButton, spacer, deleteButton]
    }
    private func addEditBarButtonitems() {
        clearButton.addTarget(self, action: #selector(didTapClearBarButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveBarButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelBarButton), for: .touchUpInside)
        let clearBarButton = UIBarButtonItem(customView: clearButton)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 50
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItems = [clearBarButton, spacer, saveBarButton]
    }
    private func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    private func saveImage(drawing : UIImage) -> UIImage? {
        let bottomImage = self.imageToEdit!
        let newImage = autoreleasepool { () -> UIImage in
            UIGraphicsBeginImageContextWithOptions(self.canvasView.frame.size, false, 0.0)
            bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: self.canvasView.frame.size))
            drawing.draw(in: CGRect(origin: CGPoint.zero, size: self.canvasView.frame.size))
            let createdImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return createdImage!
        }
        return newImage
    }
    private func setSize() -> CGRect {
        let containerRatio = imageView.frame.size.height/imageView.frame.size.width
        let imageRatio = imageToEdit!.size.height/imageToEdit!.size.width
        if containerRatio > imageRatio {
            return self.getHeight()
        } else {
            return self.getWidth()
        }
    }
    private func getHeight() -> CGRect {
        let containerView = imageView
        let image = imageToEdit!
        let ratio = containerView.frame.size.width / image.size.width
        let newHeight = ratio * image.size.height
        let size = CGSize(width: containerView.frame.width, height: newHeight)
        var yPosition = (containerView.frame.size.height - newHeight) / 2
        yPosition = (yPosition < 0 ? 0 : yPosition) + containerView.frame.origin.y
        let origin = CGPoint.init(x: 0, y: yPosition)
        return CGRect.init(origin: origin, size: size)
    }
    private func getWidth() -> CGRect {
        let containerView = imageView
        let image = imageToEdit!
        let ratio = containerView.frame.size.height / image.size.height
        let newWidth = ratio * image.size.width
        let size = CGSize(width: newWidth, height: containerView.frame.height)
        let xPosition = ((containerView.frame.size.width - newWidth) / 2) + containerView.frame.origin.x
        let yPosition = containerView.frame.origin.y
        let origin = CGPoint.init(x: xPosition, y: yPosition)
        return CGRect.init(origin: origin, size: size)
    }
    
    // MARK: - Selectors
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    @objc private func didTapAnnotationButton() {
        isEditActive = true
        addEditBarButtonitems()
        canvasView.drawing = PKDrawing()
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        self.view.addSubview(canvasView)
        canvasView.frame = setSize()
        canvasView.becomeFirstResponder()
    }
    @objc private func didTapDeleteButton() {
        delegate?.deleteImage(photoIndex: indexOfImage, noteIndex: indexOfNote)
        dismiss(animated: true)
    }
    @objc private func didTapCancelBarButton() {
        isEditActive = false
        addBarButtonItems()
        canvasView.drawing = PKDrawing()
        canvasView.removeFromSuperview()
        toolPicker.removeObserver(canvasView)
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        imageView.becomeFirstResponder()
    }
    @objc private func didTapClearBarButton() {
        canvasView.drawing = PKDrawing()
    }
    @objc private func didTapSaveBarButton() {
        let drawing = canvasView.drawing.image(from: self.canvasView.bounds, scale: 0)
        if let editedImage = saveImage(drawing: drawing){
            // Save image to photo gallery
            UIImageWriteToSavedPhotosAlbum(editedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            // Add image to NoteMediaTableViewCell
            delegate?.replaceImage(with: editedImage, noteIndex: indexOfNote, photoIndex: indexOfImage)
        }
        dismiss(animated: true)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
}
