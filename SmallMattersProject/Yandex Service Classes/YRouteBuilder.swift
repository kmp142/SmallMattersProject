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
        options.vehicleType = YMKDrivingVehicleType.init(rawValue: 0)!
        return options
    }()

    var searchSession: YMKDrivingSummarySession?

    func calculateDistance(from: YMKRequestPoint, to: YMKRequestPoint, completion: @escaping ([YMKDrivingSummary]?, Error?) -> Void){

        drivingRouter = YMKDirections.sharedInstance().createDrivingRouter(withType: .combined)

        let drivingRouteHandler = { (drivingRoutes: [YMKDrivingSummary]?, error: Error?) -> Void in
            completion(drivingRoutes, error)
        }

        searchSession = drivingRouter
            .requestRoutesSummary(
                with: [from, to],
                drivingOptions: drivingOptions,
                vehicleOptions: vehicleOptions,
                summaryHandler: drivingRouteHandler)
    }
}
