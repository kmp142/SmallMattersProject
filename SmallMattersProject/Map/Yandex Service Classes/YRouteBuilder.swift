//
//  Distance.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.03.2024.
//

import Foundation
import YandexMapsMobile

//TODO: update response handling

class YRouteBuilder {

    var drivingRouter: YMKDrivingRouter = YMKDirections.sharedInstance().createDrivingRouter(withType: .combined)

    let drivingOptions: YMKDrivingOptions = {
        let options = YMKDrivingOptions()
        options.initialAzimuth = 0
        options.routesCount = 3
        return options
    }()

    let vehicleOptions = {
        let options = YMKDrivingVehicleOptions()
        options.vehicleType = YMKDrivingVehicleType.moto
        options.weight = 200
        options.weight = 100
        return options
    }()

    var searchSession: YMKDrivingSummarySession?

    func calculateDistance(completion: @escaping ([YMKDrivingSummary]) -> Void) {
        let points = [
            YMKRequestPoint(point: YMKPoint(latitude: 25.196141, longitude: 55.278543), type: .waypoint, pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(point: YMKPoint(latitude: 25.171148, longitude: 55.238034), type: .waypoint, pointContext: nil, drivingArrivalPointId: nil)
        ]

        drivingRouter = YMKDirections.sharedInstance().createDrivingRouter(withType: .combined)

        searchSession = drivingRouter
            .requestRoutesSummary(
                with: points,
                drivingOptions: drivingOptions,
                vehicleOptions: vehicleOptions,
                summaryHandler: drivingRouteHandler)
    }

    func drivingRouteHandler(drivingRoutes: [YMKDrivingSummary]?, error: Error?) {
        if error != nil {
            return
        }

        if drivingRoutes != nil {
            print(drivingRoutes?[0].weight.distance.value as Any)
            return
        }
    }
}
