//
//  MapView.swift
//  SmallMattersProject
//
//  Created by Dmitry on 24.03.2024.
//

import Foundation
import UIKit
import YandexMapsMobile
import Combine

protocol MapViewControllerInterface: AnyObject {}

class MapViewController: UIViewController, MapViewControllerInterface {


    // Prperty uses for select animation duration for current real location
    var isFirstAnimation: Bool = true

    lazy var mapView: YMKMapView = {
        let mapView = YBaseMapView().mapView
        mapView?.mapWindow.map.isRotateGesturesEnabled = false
        return mapView!
    }()

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Введите адрес"
        sb.autocorrectionType = .no
        sb.clipsToBounds = true
        sb.searchBarStyle = .minimal
        sb.delegate = self
        return sb
    }()

    lazy var backgroungSearchBarCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var findUserLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Где я", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor

        // Установка смещения тени (ширина, высота)
        button.layer.shadowOffset = CGSize(width: 10, height: 10)

        // Установка радиуса размытия тени
        button.layer.shadowRadius = 20

        // Установка прозрачности тени
        button.layer.shadowOpacity = 0.5

//        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(findUserLocationButtonTapped), for: .touchUpInside)
        return button
    }()

    private var mapInputListener: InputListener?

    private var subscriptions = Set<AnyCancellable>()

    var viewModel: MapViewModelInterface?

    init(viewModel: MapViewModelInterface?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addMapTapListener()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.updateUserRealLocation()
        setCurrentLocationPlacemark()
        createSubscriptionOnSelectedLocation()
        createSubscriptionOnAddressName()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        subscriptions.removeAll()
        isFirstAnimation = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        findUserLocationButton.layer.shadowColor = UIColor.black.cgColor
        findUserLocationButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        findUserLocationButton.layer.shadowRadius = 20
        findUserLocationButton.layer.shadowOpacity = 0.5
    }

    private func configureNavigationBar() {
        title = "Выберите геопозицию"
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, 
                                         target: self,
                                         action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    private func addObserversOnKeyboard() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default
            .addObserver(self,
                        selector: #selector(keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }

        backgroungSearchBarCoverView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.top)
            make.left.bottom.right.equalToSuperview()
        }

        findUserLocationButton.snp.makeConstraints { make in
            make.width.equalTo(92)
            make.height.equalTo(40)
            make.bottom.equalTo(searchBar.snp.top).offset(-8)
            make.right.equalToSuperview().inset(8)
        }
    }

    private func updateSearchBarBottomConstraints(bottomConstant: CGFloat, height: CGFloat?) {
        DispatchQueue.main.async {
            self.searchBar.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(bottomConstant)
                if let height = height {
                    make.height.equalTo(height)
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    private func configureView() {
        configureSubviews()
        setupConstraints()
        configureNavigationBar()
        addObserversOnKeyboard()
    }

    private func configureSubviews() {
        view.addSubview(mapView)
        view.backgroundColor = .white
        mapView.addSubview(backgroungSearchBarCoverView)
        mapView.addSubview(searchBar)
        mapView.addSubview(findUserLocationButton)
    }

    private func setCurrentLocationPlacemark() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let viewModel = viewModel as? MapViewModel {
                viewModel.$userRealLocation
                    .compactMap {$0}
                    .sink { coordinates in
                    let point = YMKPoint(latitude: coordinates!.latitude,
                                         longitude: coordinates!.longitude)
                    self.removeAllPlacemarks()
                    self.addPlacemarkOnMap(latitude: point.latitude,
                                           longitude: point.longitude)
                    self.moveMapCamera(toPoint: point,
                                       zoom: 13,
                                       animationDuration: self.isFirstAnimation ? 0 : 0.3)
                }.cancel()
            }
            self.isFirstAnimation = false
        }
    }

    // MARK: - Work with YMaps

    func addPlacemarkOnMap(latitude: Double, longitude: Double) {
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
        }
    }

    func moveMapCamera(toPoint: YMKPoint, zoom: Float, animationDuration: Float) {
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

    private func addMapTapListener() {
        mapInputListener = InputListener(viewController: self)
        mapView.mapWindow.map.addInputListener(with: mapInputListener!)
    }

    func selectedNewPoint(point: YMKPoint) {
        viewModel?.updateCurrentSelectedLocation(with: point)
        searchBar.resignFirstResponder()
    }

    private func createSubscriptionOnSelectedLocation() {
        if let viewModel = viewModel as? MapViewModel {
            viewModel.$currentSelectedLocation.sink { [weak self] coordinates in
                guard let coordinates = coordinates, let self = self else { return }

                let point = YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)
                self.removeAllPlacemarks()
                self.addPlacemarkOnMap(latitude: point.latitude, longitude: point.longitude)
                self.moveMapCamera(toPoint: point, zoom: 17, animationDuration: 0.5)
            }.store(in: &subscriptions)
        }
    }

    private func createSubscriptionOnAddressName() {
        if let viewModel = viewModel as? MapViewModel {
            viewModel.$currentSelectedLocationAddress.sink { addressName in
                self.searchBar.text = addressName
            }.store(in: &subscriptions)
        }
    }

    func removeAllPlacemarks() {
        self.mapView.mapWindow.map.mapObjects.clear()
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc func keyboardWillShow(notification: Notification) {
        // Получите размер клавиатуры из уведомления
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.updateSearchBarBottomConstraints(bottomConstant: keyboardSize.height, height: 44)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        updateSearchBarBottomConstraints(bottomConstant: 24, height: 64)
    }

    @objc private func findUserLocationButtonTapped() {
        viewModel?.updateUserRealLocation()
        setCurrentLocationPlacemark()
        searchBar.resignFirstResponder()
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel?.setAddressCoordinatesByName(addressName: text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - Utility classess for YMap

final private class InputListener: NSObject, YMKMapInputListener {

    weak var viewController: MapViewController?

    init(viewController: MapViewController) {
        self.viewController = viewController
    }

    func onMapTap(with map: YMKMap, point: YMKPoint) {
        viewController?.selectedNewPoint(point: point)
    }

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
    }
}



