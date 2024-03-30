//
//  YandeMapsInteractor.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.03.2024.
//

import Foundation
import YandexMapsMobile

final class YandexMapsAddressSearchInteractor {
    
    lazy var searchManager: YMKSearchManager? = YMKSearch.sharedInstance().createSearchManager(with: .combined)

    var searchSession: YMKSearchSession?

    let BOUNDING_BOX = YMKBoundingBox(
      southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
      northEast: YMKPoint(latitude: 55.95, longitude: 37.82)
    )

    let searchOptions: YMKSearchOptions = {
        let options = YMKSearchOptions()
        options.searchTypes = .geo
        options.resultPageSize = 32
        return options
    }()

    func searchAddressByString(_ address: String?, completion: @escaping (YMKSearchResponse) -> Void) {

      guard let address = address else { return }

      searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)

      let responseHandler = { (searchResponse: YMKSearchResponse?, error: Error?) -> Void in
          if let response = searchResponse {
              completion(response)
          } else {
              print("error happened \(String(describing: error?.localizedDescription))")
          }
      }

      searchSession = searchManager!.submit(
          withText: address,
          geometry: YMKGeometry(boundingBox: BOUNDING_BOX),
          searchOptions: YMKSearchOptions(),
          responseHandler: responseHandler
      )
    }

    func searchAddressByCoordinates(latitude: Double, longitude: Double, completion: @escaping (YMKSearchResponse) -> Void) {

        let point = YMKPoint(latitude: latitude, longitude: longitude)

        let responseHandler = { (searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                completion(response)
            } else {
                print("error happened \(String(describing: error?.localizedDescription))")
            }
        }
        
        searchSession = searchManager!.submit(
            with: point,
            zoom: 0,
            searchOptions: searchOptions,
            responseHandler: responseHandler)
    }
}
