//
//  EarthquakeFlowUsecase.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/03.
//

import Alamofire
import Combine
import Foundation
import GoogleMaps

final class EarthquakeFlowUsecase {
    func execute() -> Publishers.Map<AnyPublisher<[JMAQuake], AFError>, [Earthquake]> {
        return P2PquakeRepository().getEarthquake().value().map { jmaQuakes in
            return jmaQuakes.map { jmaQuake in
                let jmaHypocenter = jmaQuake.earthquake.hypocenter
                let hypocenter = Hypocenter(
                    time: jmaQuake.earthquake.time,
                    place: jmaHypocenter?.name,
                    magnitude:
                        jmaHypocenter?.magnitude.map { String($0) },
                    depth: jmaHypocenter?.depth.map { String($0) },
                    marker: getMarker(jmaHypocenter: jmaHypocenter)
                )
                let points = jmaQuake.points?.map { point in
                    return ObservationPoint(
                        name: point.addr,
                        scale: String(point.scale)
                    )
                }
                
                return Earthquake(
                    id: jmaQuake.id,
                    hypocenter: hypocenter,
                    observationPoints: points
                )
            }
        }
    }
}

private func getMarker(jmaHypocenter: JMAHypocenter?) -> GMSMarker? {
    guard let jmaHypocenter else {
        return nil
    }
    guard let latitude = jmaHypocenter.latitude, let longitude = jmaHypocenter.longitude else {
        return nil
    }
    
    return GMSMarker(
        position: CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    )
}
