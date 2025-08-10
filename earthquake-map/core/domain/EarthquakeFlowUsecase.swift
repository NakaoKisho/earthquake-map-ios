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
    func execute() -> DataResponsePublisher<[JMAQuake]> {
        return P2PquakeRepository().getEarthquake()
    }
}
