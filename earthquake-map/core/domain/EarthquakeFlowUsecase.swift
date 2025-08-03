//
//  EarthquakeFlowUsecase.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Combine
import Foundation
import GoogleMaps

final class EarthquakeFlowUsecase {
    func execute() -> Publishers.Sequence<[GMSMarker], Never> {
        
        return [
            GMSMarker(
                position: CLLocationCoordinate2D(
                    latitude: 37.7576,
                    longitude: -122.4194
                )
            ),
            GMSMarker(
                position: CLLocationCoordinate2D(
                    latitude: 10.0000,
                    longitude: -122.4194
                )
            ),
            GMSMarker(
                position: CLLocationCoordinate2D(
                    latitude: 67.7576,
                    longitude: -122.4194
                )
            ),
            GMSMarker(
                position: CLLocationCoordinate2D(
                    latitude: 37.7576,
                    longitude: 10.4194
                )
            ),
        ].publisher
    }
}
