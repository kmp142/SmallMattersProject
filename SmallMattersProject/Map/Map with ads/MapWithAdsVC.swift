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
import SnapKit

protocol MapWithAdsVCInterface {
    
}

class MapWithAdsVC: UIViewController, MapWithAdsVCInterface {

    //MARK: - Properties

    private lazy var mapView: YMKMapView = {
        let mapView = YBaseMapView().mapView
        mapView?.mapWindow.map.isRotateGesturesEnabled = false
        return mapView!
    }()

    private lazy var adInfoViewTapGR: UITapGestureRecognizer = {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(adInfoViewTapped))
        return tapGR
    }()

    private lazy var adInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.addGestureRecognizer(adInfoViewTapGR)
        return view
    }()

    private lazy var adNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var adAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var distanceToAdLabel: UILabel = {
        let label = UILabel()
        label.text = "от вас"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var adDeadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок выполнения: "
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var adDeadlineIndicatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()

    private lazy var hideAdInfoViewButton: UIButton = {
        let button = UIButton(configuration: .gray())
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.addTarget(self, action: #selector(hideAdInfoViewButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var adBountyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        return label
    }()

    private var viewModel: MapWithAdsViewModelInterface?

    private var subscriptions = Set<AnyCancellable>()

    private var adInfoViewTopConstraint: Constraint?

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
        configureView()
        createSubscriptions()
    }

    // adInfoView constraints setting here because tabBar access required
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAdInfoViewHideConstraints()
        setupAdInfoViewSubviewsConstraints()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        adInfoView.snp.removeConstraints()
        adInfoView.subviews.forEach { $0.snp.removeConstraints() }
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(mapView)
        mapView.addSubview(adInfoView)
        setupMapViewConstraints()
        addSubviewsOnAdInfoView()
    }

    private func setupMapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func addSubviewsOnAdInfoView() {
        adInfoView.addSubview(adNameLabel)
        adInfoView.addSubview(adAddressLabel)
        adInfoView.addSubview(distanceToAdLabel)
        adInfoView.addSubview(adDeadlineLabel)
        adInfoView.addSubview(adDeadlineIndicatorImageView)
        adInfoView.addSubview(hideAdInfoViewButton)
        adInfoView.addSubview(adBountyLabel)
    }

    private func setupAdInfoViewSubviewsConstraints() {

        adNameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(8)
            make.right.equalTo(hideAdInfoViewButton.snp.left).offset(-4)
        }

        hideAdInfoViewButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(8)
            make.height.width.equalTo(24)
        }

        adDeadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(adNameLabel.snp.bottom).offset(4)
            make.left.equalTo(adNameLabel.snp.left)
        }

        adDeadlineIndicatorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalTo(adDeadlineLabel.snp.right).offset(4)
            make.centerY.equalTo(adDeadlineLabel.snp.centerY)
        }

        adAddressLabel.snp.makeConstraints { make in
            make.left.equalTo(adNameLabel.snp.left)
            make.top.equalTo(adDeadlineLabel.snp.bottom).offset(4)
        }

        distanceToAdLabel.snp.makeConstraints { make in
            make.left.equalTo(adNameLabel.snp.left)
            make.top.equalTo(adAddressLabel.snp.bottom).offset(4)
        }

        adBountyLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(4)
        }
    }

    private func setupAdInfoViewHideConstraints() {
        if let tabBar = self.tabBarController?.tabBar {
            adInfoView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(4)
                make.height.equalTo(120)
                adInfoViewTopConstraint = make.top.equalTo(tabBar.snp.top).constraint
            }
        }
    }

    private func showAdInfoView(with ad: Ad) {
        guard let topConstraint = adInfoViewTopConstraint else { return }
        topConstraint.update(offset: -124)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    private func configureAdInfoView(with ad: Ad) {
        adNameLabel.text = ad.title
        adDeadlineIndicatorImageView.image = DeadlineIndicator.getImageByDeadline(date: ad.deadline)
        adBountyLabel.text = "\(Int(ad.bounty))р."
        switch ad.distanceToUser {
        case 0...9999:
            self.distanceToAdLabel.text = "\(Int(ad.distanceToUser)) м. от вас"
        default:
            self.distanceToAdLabel.text = "\(Int(ad.distanceToUser/1000)) км. от вас"
        }
        
        viewModel?.getSelectedAdAddressName(location: Location(latitude: ad.locationLatitude, longitude: ad.locationLongitude)) { addressName in
            self.adAddressLabel.text = addressName
        }
    }

    //MARK: - YMaps

    func addPlacemarkOnMap(latitude: Double, longitude: Double, tapListener: YMKMapObjectTapListener?, userData: Ad?, icon: UIImage) {
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        DispatchQueue.main.async {
            let viewPlacemark = self.mapView.mapWindow.map.mapObjects.addPlacemark()
            viewPlacemark.geometry = point

            viewPlacemark.setIconWith(
                icon,
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

    private func removeAllPlacemarks() {
        DispatchQueue.main.async {
            self.mapView.mapWindow.map.mapObjects.clear()
        }
    }

    //MARK: - Binding

    private func createSubscriptions() {
        createSubscriptionOnAllAds()
        createSubscriptionOnSelectedAd()
        createSubscriptionOnUserLocation()
    }

    private func createSubscriptionOnAllAds() {
        if let viewModel = viewModel as? MapWithAdsViewModel {
            viewModel.$ads
                .compactMap{ $0 }
                .sink { [weak self] ads in

                    self?.removeAllPlacemarks()
                    for ad in ads {
                        self?.addPlacemarkOnMap(latitude: ad.locationLatitude, longitude: ad.locationLongitude, tapListener: self, userData: ad, icon: UIImage(named: "bluePin")!)
                    }
                }.store(in: &subscriptions)
        }

    }

    private func createSubscriptionOnSelectedAd() {
        if let viewModel = viewModel as? MapWithAdsViewModel {
            viewModel.$selectedAd
                .compactMap{ $0 }
                .sink { [weak self] ad in
                    self?.configureAdInfoView(with: ad)
                    self?.showAdInfoView(with: ad)
                }.store(in: &subscriptions)
        }
    }

    private func createSubscriptionOnUserLocation() {
        if let viewModel = viewModel as? MapWithAdsViewModel {
            viewModel.$userLocation
                .compactMap { $0 }
                .sink { [weak self] location in
                    self?.addPlacemarkOnMap(latitude: location.latitude, longitude: location.longitude, tapListener: nil, userData: nil, icon: UIImage(named: "circle")!)
                    self?.moveMapCamera(toPoint: YMKPoint(latitude: location.latitude, longitude: location.longitude), zoom: 13, animationDuration: 0)
                }.store(in: &subscriptions)
        }
    }

    //MARK: - Objc targets

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func hideAdInfoViewButtonTapped() {
        adInfoView.snp.removeConstraints()
        setupAdInfoViewHideConstraints()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func adInfoViewTapped() {
        Task { @MainActor in
            let adAuthor: User? = await viewModel?.getSelectedAdAuthor()
            if let viewModel = viewModel as? MapWithAdsViewModel, let author = adAuthor, let ad = viewModel.selectedAd {
                let adDetailScreenVM = AdDetailsScreenViewModel(ad: ad, author: author, networkService: NetworkService())
                let adDetailScreenVC = AdDetailsViewController(viewModel: adDetailScreenVM)
                navigationController?.pushViewController(adDetailScreenVC, animated: true)
            }
        }
    }
}

extension MapWithAdsVC: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else {
            return false
        }
        if let viewModel = viewModel as? MapWithAdsViewModel {
            viewModel.selectedAd = (placemark.userData as! Ad)
        }
        moveMapCamera(toPoint: placemark.geometry, zoom: 17, animationDuration: 0.3)
        return true
    }
}

