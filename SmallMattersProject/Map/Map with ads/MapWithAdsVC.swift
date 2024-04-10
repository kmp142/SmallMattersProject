//
//  ClusterizedMapViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.03.2024.
//

import Foundation
import UIKit
import YandexMapsMobile
import Combine

protocol MapWithAdsVCInterface {
    
}

//TODO: layout ad view

class MapWithAdsVC: UIViewController {

    //MARK: - Properties

    private lazy var mapView: YMKMapView = {
        let mapView = YBaseMapView().mapView
        mapView?.mapWindow.map.isRotateGesturesEnabled = false
        return mapView!
    }()

    private lazy var adInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    private lazy var adNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private lazy var adAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private lazy var distanceToAdLabel: UILabel = {
        let label = UILabel()
        label.text = "от вас"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private lazy var adDeadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок выполнения: "
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private var viewModel: MapWithAdsViewModelInterface?

    private var subscriptions = Set<AnyCancellable>()

    //MARK: - Initialization

    init(viewModel: MapWithAdsViewModelInterface?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createSubscriptionOnViewModel()
        configureView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureAdInfoView()
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(mapView)
        mapView.addSubview(adInfoView)
        setupMapViewConstraints()
//        configureAdInfoView()
    }

    private func setupMapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func configureAdInfoView() {
        adInfoView.addSubview(adNameLabel)
        adInfoView.addSubview(adAddressLabel)
        adInfoView.addSubview(adDeadlineLabel)
        adInfoView.addSubview(distanceToAdLabel)

        adNameLabel.text = "Название объявления"
        adAddressLabel.text = "Казань, Технократия"

        if let tabBar = self.tabBarController?.tabBar {
            adInfoView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(8)
                make.height.equalTo(70)
                make.bottom.equalTo(tabBar.snp.top).offset(-10)
            }
        }

        adNameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(4)
        }

        adAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(adNameLabel.snp.bottom).inset(4)
            make.left.equalTo(adNameLabel.snp.left)
        }

        adDeadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(adAddressLabel.snp.bottom).inset(4)
            make.left.equalTo(adAddressLabel.snp.left)
        }

        distanceToAdLabel.snp.makeConstraints { make in
            make.top.equalTo(adDeadlineLabel.snp.bottom).inset(4)
            make.left.equalTo(adDeadlineLabel.snp.left)
        }

    }

    //MARK: - YMaps

    func addPlacemarkOnMap(latitude: Double, longitude: Double, tapListener: YMKMapObjectTapListener?, userData: Ad?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let point = YMKPoint(latitude: latitude, longitude: longitude)
            let viewPlacemark: YMKPlacemarkMapObject = self.mapView.mapWindow.map.mapObjects.addPlacemark()
            viewPlacemark.geometry = point
            viewPlacemark.setIconWith(
                UIImage(named: "circle")!,
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
            if let tapListener = tapListener, let userData = userData {
                viewPlacemark.addTapListener(with: tapListener)
                viewPlacemark.userData = userData
            }
        }
    }

    private func moveMapCamera(toPoint: YMKPoint, zoom: Float, animationDuration: Float) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: toPoint,
                zoom: zoom,
                azimuth: .zero,
                tilt: .zero
            ),
            animation: YMKAnimation(type: .linear, duration: animationDuration),
            cameraCallback: nil
        )
    }

    func removeAllPlacemarks() {
        self.mapView.mapWindow.map.mapObjects.clear()
    }

    //MARK: - Binding

    private func createSubscriptionOnViewModel() {
        if let viewModel = viewModel as? MapWithAdsViewModel {
            viewModel.$ads
                .compactMap{ $0 }
                .sink { [weak self] ads in
                    self?.removeAllPlacemarks()
                    for ad in ads {
                        self?.addPlacemarkOnMap(latitude: ad.location.latitude, longitude: ad.location.longitude, tapListener: self, userData: ad)
                    }
                }.store(in: &subscriptions)
        }
    }

    //MARK: - Objc targets

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension MapWithAdsVC: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else {
            return false
        }
        moveMapCamera(toPoint: placemark.geometry, zoom: 17, animationDuration: 0.5)
        return true
    }
}

