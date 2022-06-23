//
//  MapViewController.swift
//  LandscapeApp
//
//  Created by Max Park on 5/15/22.
//

import UIKit

// MARK: - Protocols
protocol MapViewControllerDelegate: AnyObject {
    func didTapMenuButton()
    func didTapAnnotationButton()
    func retreiveMarkers() -> [Marker]
    func deselectAllPins(except pinIndex: Int)
}

class MapViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: MapViewControllerDelegate?
    private var animator: DraggableTransitionDelegate?
    var markers: [Marker] = []
    
    // MARK: - UI Components
    private let mapImageView: UIImageView = CustomMapImageView(image: UIImage(named: "MapExample"))
    private let scrollView: UIScrollView = CustomScrollView()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupViews()
        addBarButtonItems()
//        configureMarkers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor),
            
            mapImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mapImageView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            mapImageView.widthAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor),
            mapImageView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
        ])
        scrollView.zoomScale = scrollView.minimumZoomScale
        
    }
    
    // MARK: - Public Methods
    public func configureMarkers(marker: Marker) {
        let markerWidth: CGFloat = 48
        let x = mapImageView.frame.midX // 597
        let y = mapImageView.frame.midY // 380
        let origin = CGPoint(x: x - (markerWidth / 2), y: y - (markerWidth / 2))
        let size = CGSize(width: markerWidth, height: markerWidth)
        
        markers.append(marker)
        scrollView.addSubview(marker)
        
        marker.delegate = self
        marker.isUserInteractionEnabled = true
        
        marker.x = x / mapImageView.width
        marker.y = y / mapImageView.height
        
        marker.frame = CGRect(origin: origin, size: size)
    }
    
    // MARK: - Private Methods
    private func configureViewController() {
        title = "Project Name"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = UIColor(named: "NavigationGray")
        navigationController?.navigationBar.isTranslucent = false
    }
    private func setupViews() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width, height: view.height)
        scrollView.backgroundColor = .white
        scrollView.addSubview(mapImageView)
        view.addSubview(scrollView)
    }
    private func updateMarkers() {
        markers.forEach { marker in
            let x = mapImageView.frame.origin.x + marker.x * mapImageView.frame.width
            let y = mapImageView.frame.origin.y + marker.y * mapImageView.frame.height
            
            marker.x = x / mapImageView.width
            marker.y = y / mapImageView.height
            marker.center = CGPoint(x: x, y: y)
        }
    }
    private func addBarButtonItems() {
        // MARK: Left bar button items
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackBarButton)
        )
        let sidebarButton = UIBarButtonItem(
            image: UIImage(systemName: "sidebar.left"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton)
        )
        let annotationButton = UIBarButtonItem(
            image: UIImage(systemName: "paintbrush.pointed.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapAnnotationButton)
        )
        // MARK: Right bar button items
        let weatherButton = UIBarButtonItem(
            image: UIImage(systemName: "thermometer"),
            style: .plain,
            target: self,
            action: #selector(tappedButton)
        )
        let conditionButton = UIBarButtonItem(
            image: UIImage(systemName: "doc"),
            style: .plain,
            target: self,
            action: #selector(tappedButton)
        )
        let exportButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(tappedButton)
        )
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 50
        
        navigationItem.leftBarButtonItems = [
            backButton,
            spacer,
            sidebarButton,
            annotationButton
        ]
        navigationItem.rightBarButtonItems = [
            exportButton,
            conditionButton,
            weatherButton,
        ]
    }
    
    // MARK: - Selectors
    @objc private func didTapBackBarButton() {
        dismiss(animated: true)
    }
    @objc private func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    @objc private func didTapAnnotationButton() {
        delegate?.didTapAnnotationButton()
    }
    @objc private func tappedButton() {
        // TODO: Weather, Condition, Export buttons
    }
}

// MARK: - Scroll View Delegate
extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateMarkers()
    }
}

// MARK: - Marker Delegate
extension MapViewController: MarkerDelegate {
    func deselectAllPins(except pinIndex: Int) {
        delegate?.deselectAllPins(except: pinIndex)
    }
    
    func updateMarkerPosition(x: CGFloat, y: CGFloat) {
        for marker in markers {
            if !marker.isDragging { continue }
            
            marker.x = x / mapImageView.width
            marker.y = y / mapImageView.height
            
            marker.center = CGPoint(x: x, y: y)
        }
    }
}

