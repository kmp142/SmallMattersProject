//
//  AdOnMap.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation
import UIKit
import YandexMapsMobile

class AdOnMapVC: UIViewController {

    //MARK: - Properties

    private lazy var mapView: YMKMapView = {
        let mapView = YBaseMapView().mapView
        mapView?.mapWindow.map.isRotateGesturesEnabled = false
        return mapView!
    }()

    private let ad: Ad

    //MARK: - Initialization

    init(ad: Ad) {
        self.ad = ad
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveMapCamera(latitude: ad.locationLatitude, longitude: ad.locationLongitude, zoom: 17, animationDuration: 0)
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addPlacemarkOnMap(latitude: ad.locationLatitude, longitude: ad.locationLongitude)
    }

    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close,
                                         target: self,
                                         action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.barStyle = .default
    }

    //MARK: - YMaps

    private func addPlacemarkOnMap(latitude: Double, longitude: Double) {

        let point = YMKPoint(latitude: latitude, longitude: longitude)
        let viewPlacemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        viewPlacemark.geometry = point

        viewPlacemark.setIconWith(
            UIImage(named: "bluePin")!,
            style: YMKIconStyle(
                anchor: CGPoint(x: 0.2, y: 0.2) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: true,
                visible: true,
                scale: 0.15,
                tappableArea: nil
            )
        )
    }

    private func moveMapCamera(latitude: Double, longitude: Double, zoom: Float, animationDuration: Float) {

        let point = YMKPoint(latitude: latitude, longitude: longitude)

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: point,
                zoom: zoom,
                azimuth: .zero,
                tilt: .zero
            ),
            animation: YMKAnimation(type: .linear, duration: animationDuration),
            cameraCallback: nil
        )
    }

    //MARK: - Objc targets

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}
